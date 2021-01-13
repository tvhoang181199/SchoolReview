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

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostCellProtocol, CheckUserBlockedProtocol {

    @IBOutlet weak var myPostsTableView: UITableView!
    
    // quick access properties
    let currentUser = UserDefaults.standard
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    
    // data properties
    var postsList = [Post]()
    
    //listener
    var firestoreListener: ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPostsTableView.delegate = self
        myPostsTableView.dataSource = self
        myPostsTableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostTableViewCell")
        
        myPostsTableView.contentInset = UIEdgeInsets(top:15, left: 0, bottom: 15, right: 0)
        myPostsTableView.reloadData()
        
        fetchData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - fetchData
    func fetchData() {
        hud.show(in: self.view)
        firestoreListener = db.collection("posts").whereField("userID", isEqualTo: currentUser.string(forKey: "userID")!).order(by: "createdDate", descending: true).addSnapshotListener() { (snapshot, error) in
            if let error = error {
                self.hud.dismiss()
                Toast.show(message: error.localizedDescription, controller: self)
            }
            else {
                print("Fetched My Posts Data: \(snapshot?.description ?? "")")
                self.postsList.removeAll()
                for document in snapshot!.documents {
                    let post = Post(document as DocumentSnapshot)
                    self.postsList.append(post)
                    self.presentData()
                }
                self.hud.dismiss()
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
    
}
