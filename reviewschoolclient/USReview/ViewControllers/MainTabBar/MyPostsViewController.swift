//
//  MyPostsViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 12/01/2021.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

import JGProgressHUD
import SCLAlertView

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellProtocol {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myPostsTableView: UITableView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyPostLabel: UILabel!
    
    // quick access properties
    let currentUser = UserDefaults.standard
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    
    // data properties
    var postsList = [Post]()
    var maxPostsFetched: Int = 5
    
    // Listener
    var firestoreListener: ListenerRegistration? = nil

    // For loading
    var isBottomLoading: Bool = false
    private let refreshControl = UIRefreshControl()
    
    // Textfields handler
    var isTextFieldEditing: Bool = false
    
    // For layout
    var safeAreaBottomInset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.windows[0]
        safeAreaBottomInset = window.safeAreaInsets.bottom
        
        emptyPostLabel.alpha = 1
        emptyPostLabel.isHidden = true

        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refetchData), for: .valueChanged)
        myPostsTableView.refreshControl = refreshControl
        
        myPostsTableView.delegate = self
        myPostsTableView.dataSource = self
        myPostsTableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostTableViewCell")
        
        myPostsTableView.contentInset = UIEdgeInsets(top:10, left: 0, bottom: 15, right: 0)
        myPostsTableView.reloadData()
        
        // Observe keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Observe user was blocked or not
        NotificationCenter.default.addObserver(self, selector: #selector(userWasBlocked(notification:)), name: Notification.Name("UserWasBlocked"), object: nil)
        
        fetchData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1) {
            self.isTextFieldEditing = true
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            containerBottomConstraint.constant = keyboardHeight - safeAreaBottomInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1) {
            self.isTextFieldEditing = false
        }
        containerBottomConstraint.constant = 0
    }
    
    @objc func userWasBlocked(notification: NSNotification) {
        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alertView.addButton("OK") {
            if let appDomain = Bundle.main.bundleIdentifier {
                self.currentUser.removePersistentDomain(forName: appDomain)
            }
            try! Auth.auth().signOut()
            let loginNavigationController = UIStoryboard.loginNavigationController()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController!)
        }
        alertView.showWarning("Warning", subTitle: "Your account has been blocked by admin. Your session has been stopped.")
    }
    
    func presentData() {
        myPostsTableView.reloadData()
    }
    
    // MARK: - UIButton actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        firestoreListener?.remove()
        firestoreListener = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Protocols
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 400
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 400
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.delegate = self
        cell.setPost(postsList[indexPath.row])
        
        return cell
    }
    
    private func createLoadingFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: myPostsTableView.frame.size.width, height: 60))
        let hudLoading = UIActivityIndicatorView()
        
        footerView.addSubview(hudLoading)
        hudLoading.center = footerView.center
        hudLoading.startAnimating()
        
        return footerView
    }
    
    // MARK: - fetchData
    func fetchData() {
        // Create loading animation
        if (isBottomLoading) {
            self.myPostsTableView.tableFooterView = createLoadingFooter()
        }
        else {
            hud.show(in: self.view)
        }
        
        firestoreListener = db.collection("posts")
            .whereField("userID", isEqualTo: currentUser.string(forKey: "userID")!)
            .order(by: "createdDate", descending: true)
            .limit(to: maxPostsFetched)
            .addSnapshotListener() { (snapshot, error) in
            if let error = error {
                self.hud.dismiss()
                Toast.show(message: error.localizedDescription, controller: self)
            }
            else {
                print("Fetched My Posts Data: \(snapshot?.description ?? "")")
                if ((self.postsList.count < (snapshot?.documents.count)! && self.isBottomLoading == true) ||
                        self.isBottomLoading == false) {
                    self.postsList.removeAll()
                    for document in snapshot!.documents {
                        let post = Post(document as DocumentSnapshot)
                        self.postsList.append(post)
                        self.presentData()
                    }
                }
                
                // Disable loading animation
                self.hud.dismiss()
                if (self.isBottomLoading) {
                    self.myPostsTableView.tableFooterView = nil
                    self.isBottomLoading = false
                    self.myPostsTableView.reloadData()
                }
                
                // Check if postsList is empty
                if self.postsList.count == 0 {
                    UIView.animate(withDuration: 0.3,
                                   delay: 0.1,
                                   options: .curveEaseOut) {
                        self.emptyPostLabel.alpha = 1
                    } completion: { (value) in
                        self.emptyPostLabel.isHidden = false
                    }
                }
                else {
                    UIView.animate(withDuration: 0.3,
                                   delay: 0.1,
                                   options: .curveEaseOut) {
                        self.emptyPostLabel.alpha = 0
                    } completion: { (value) in
                        self.emptyPostLabel.isHidden = true
                    }
                }
            }
        }
    }
    
    @objc func refetchData() {
        maxPostsFetched = 5
        
        firestoreListener?.remove()
        firestoreListener = db.collection("posts")
            .whereField("userID", isEqualTo: currentUser.string(forKey: "userID")!)
            .order(by: "createdDate", descending: true)
            .limit(to: maxPostsFetched)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    self.hud.dismiss()
                    Toast.show(message: error.localizedDescription, controller: self)
                }
                else {
                    self.postsList.removeAll()
                    for document in snapshot!.documents {
                        let post = Post(document as DocumentSnapshot)
                        self.postsList.append(post)
                        self.presentData()
                    }
                    
                    // Disable loading animation
                    self.refreshControl.endRefreshing()
                    
                    // Check if postsList is empty
                    if self.postsList.count == 0 {
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.1,
                                       options: .curveEaseOut) {
                            self.emptyPostLabel.alpha = 1
                        } completion: { (value) in
                            self.emptyPostLabel.isHidden = false
                        }
                    }
                    else {
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.1,
                                       options: .curveEaseOut) {
                            self.emptyPostLabel.alpha = 0
                        } completion: { (value) in
                            self.emptyPostLabel.isHidden = true
                        }
                    }
                }
            }
    }
    
    // MARK: - Post Cell Protocol
    func editPostDidTapped(_ data: Post) {
        let vc = UIStoryboard.addPostViewController()
        vc?.postData = data
        vc?.titleString = "EDIT POST"
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    func callBackError(_ error: Error) {
        Toast.show(message: error.localizedDescription, controller: self)
    }
    
    func deleteCommentCallBack(post: Post, index: Int) {
        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alertView.addButton("Yes") {
            self.db.collection("posts").document(post.postID!).updateData(["comments": FieldValue.arrayRemove([[
                "userID": post.comments![index]["userID"] as! String,
                "userName": post.comments![index]["userName"] as! String,
                "schoolID": post.comments![index]["schoolID"] as! String,
                "content": post.comments![index]["content"] as! String,
                "commentID": post.comments![index]["commentID"] as! String
            ]])
            ])
        }
        alertView.addButton("No") {
        }
        alertView.showWarning("Warning", subTitle: "Do you want to delete this comment?")
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == myPostsTableView) {
            if (isTextFieldEditing) {
                view.endEditing(true)
            }
            let position = scrollView.contentOffset.y
            if (position > myPostsTableView.contentSize.height+100-scrollView.frame.size.height && myPostsTableView.contentSize.height > containerView.frame.size.height) {
                isBottomLoading = true
                myPostsTableView.tableFooterView = createLoadingFooter()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == myPostsTableView) {
            if (postsList.count == maxPostsFetched) {
                maxPostsFetched += 5
            }
            if (isBottomLoading) {
                fetchData()
            }
        }
    }
}
