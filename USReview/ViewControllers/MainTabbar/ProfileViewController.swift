//
//  ProfileViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 03/01/2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        let loginNavigationController = UIStoryboard.loginNavigationController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController!)
    }
    
}
