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

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellProtocol, CheckUserBlockedProtocol {

    @IBOutlet weak var myPostsTableView: UITableView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    // quick access properties
    let currentUser = UserDefaults.standard
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    
    // data properties
    var postsList = [Post]()
    
    //listener
    var firestoreListener: ListenerRegistration? = nil
    
    var maxPostsFetched: Int = 5
    
    // For loading
    var isBottomLoad: Bool = false
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refetchData), for: .valueChanged)
        myPostsTableView.addSubview(refreshControl)
        
        myPostsTableView.delegate = self
        myPostsTableView.dataSource = self
        myPostsTableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostTableViewCell")
        
        myPostsTableView.contentInset = UIEdgeInsets(top:10, left: 0, bottom: 15, right: 0)
        myPostsTableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        fetchData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            containerBottomConstraint.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        containerBottomConstraint.constant = 0
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
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: myPostsTableView.frame.size.width, height: 50))
        let hudLoading = UIActivityIndicatorView()
        
        footerView.addSubview(hudLoading)
        hudLoading.center = footerView.center
        hudLoading.startAnimating()
        
        return footerView
    }
    
    // MARK: - fetchData
    func fetchData() {
        // Create loading animation
        if (isBottomLoad) {
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
                if ((self.postsList.count < (snapshot?.documents.count)! && self.isBottomLoad == true) ||
                        self.isBottomLoad == false) {
                    self.postsList.removeAll()
                    for document in snapshot!.documents {
                        let post = Post(document as DocumentSnapshot)
                        self.postsList.append(post)
                        self.presentData()
                    }
                }
                // Disable loading animation
                self.hud.dismiss()
                self.myPostsTableView.tableFooterView = nil
                self.isBottomLoad = false
            }
        }
    }
    
    @objc func refetchData() {
        maxPostsFetched = 5
        
        firestoreListener?.remove()
        firestoreListener = db.collection("posts")
            .whereField("isVerified", isEqualTo: true)
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
    
    // MARK: - Check User Blocked Protocol
    func userWasBlocked() {
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
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > myPostsTableView.contentSize.height+100-scrollView.frame.size.height) {
            print("Scroll at bottom...")
            isBottomLoad = true
            if (postsList.count == maxPostsFetched) {
                maxPostsFetched += 5
            }
            fetchData()
        }
    }
    
}
