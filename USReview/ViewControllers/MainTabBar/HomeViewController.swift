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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsTableView: UITableView!
    
    // quick access properties
    let currentUser = UserDefaults.standard
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    
    // data properties
    var postsList = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        postsTableView.contentInset = UIEdgeInsets(top:15, left: 0, bottom: 15, right: 0)
        postsTableView.reloadData()
        
        fetchData()
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
        } else {
            return 400
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.setPost(postsList[indexPath.row])
        
        return cell
    }
    
    // MARK: - fetchData
    func fetchData() {
        hud.show(in: self.view)
        db.collection("posts").addSnapshotListener() { (snapshot, error) in
            if let error = error {
                self.hud.dismiss()
                Toast.show(message: error.localizedDescription, controller: self)
            }
            else {
                self.postsList.removeAll()
                for document in snapshot!.documents {
                    let post = Post(document as DocumentSnapshot)
                    if (post.isVerified!) {
                        self.postsList.append(post)
                    }
                    self.presentData()
                }
                self.hud.dismiss()
            }
        }
    }


}
