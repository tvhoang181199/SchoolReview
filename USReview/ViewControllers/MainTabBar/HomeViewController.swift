//
//  HomeViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 03/01/2021.
//

import UIKit

import FirebaseFirestore

import SCLAlertView
import JGProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PostCellProtocol, UIScrollViewDelegate {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var postsSearchBar: UISearchBar!
    @IBOutlet weak var emptyPostLabel: UILabel!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    // Quick access properties
    let currentUser = UserDefaults.standard
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    
    // Data properties
    var maxPostsFetched: Int = 5
    var postsList = [Post]()
    
    // Listener
    var firestoreListener: ListenerRegistration? = nil
    
    // Search
    var searchQueue = OperationQueue()
    
    // For loading
    var isBottomLoad: Bool = false
    private let refreshControl = UIRefreshControl()
    
    var safeAreaBottomInset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.windows[0]
        safeAreaBottomInset = window.safeAreaInsets.bottom
        
        emptyPostLabel.alpha = 1
        emptyPostLabel.isHidden = true
        
        // Setup searchbar
        postsSearchBar.delegate = self
        
        // Setup tableview
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refetchData), for: .valueChanged)
        postsTableView.addSubview(refreshControl)
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        postsTableView.contentInset = UIEdgeInsets(top:10, left: 0, bottom: 15, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        fetchDataWithString("")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            containerBottomConstraint.constant = keyboardHeight - 49 - safeAreaBottomInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        containerBottomConstraint.constant = 0
    }
    
    func presentData() {
        postsTableView.reloadData()
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
        }
        else {
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
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: postsTableView.frame.size.width, height: 60))
        let hudLoading = UIActivityIndicatorView()
        
        footerView.addSubview(hudLoading)
        hudLoading.center = footerView.center
        hudLoading.startAnimating()
        
        return footerView
    }
    
    // MARK: - fetchData
    func fetchDataWithString(_ searchString: String) {
        // Create loading animation
        if (!isBottomLoad) {
            hud.textLabel.text = (searchString == "") ? "" : "Searching..."
            hud.show(in: self.view)
        }
        
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
                    if ((self.postsList.count < (snapshot?.documents.count)! && self.isBottomLoad == true) ||
                            self.isBottomLoad == false) {
                        self.postsList.removeAll()
                        for document in snapshot!.documents {
                            let post = Post(document as DocumentSnapshot)
                            if (searchString == "" ? true : ((post.title?.lowercased().contains(searchString.lowercased()))! ? true : false)) {
                                self.postsList.append(post)
                            }
                            self.presentData()
                        }
                    }
                    // Disable loading animation
                    self.hud.dismiss()
                    if (self.isBottomLoad) {
                        self.postsTableView.tableFooterView = nil
                        self.isBottomLoad = false
                        self.postsTableView.reloadData()
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.refreshControl.endRefreshing()
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
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        maxPostsFetched = 5
        searchQueue.addOperation {
            Thread.sleep(forTimeInterval: 0.4)
            DispatchQueue.main.async { [weak self] in
                if (self!.postsSearchBar.text != searchText) {
                    return
                }
                else {
                    self!.fetchDataWithString(searchText)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (searchBar.text != "") {
            fetchDataWithString(searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > postsTableView.contentSize.height+100-scrollView.frame.size.height) {
            isBottomLoad = true
            postsTableView.tableFooterView = createLoadingFooter()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (postsList.count == maxPostsFetched) {
            maxPostsFetched += 5
        }
        if (isBottomLoad) {
            fetchDataWithString("")
        }
    }
    
}
