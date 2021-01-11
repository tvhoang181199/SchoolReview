//
//  ProfileViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 03/01/2021.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

import SCLAlertView
import JGProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var schoolTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var statusTextField: UILabel!
    @IBOutlet weak var verifiedAccountButton: UIButton!
    
    var currentUser = UserDefaults.standard
    var isFetched = false
    
    let db = Firestore.firestore()
    
    let hud = JGProgressHUD(style:  .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (isFetched) {
            db.collection("users").document(currentUser.string(forKey: "email")!).getDocument { (snapshot, error) in
                if (snapshot?.data()!["isVerified"] as? Int != self.currentUser.integer(forKey: "isVerified")) {
                    self.fetchData()
                }
            }
        }
    }
    
    func presentData() {
        // Update data to textfields
        nameTextField.text = currentUser.string(forKey: "name")
        switch (currentUser.string(forKey: "schoolID")!) {
        case "S000":
            schoolTextField.text = "University of Science"
        case "S001":
            schoolTextField.text = "University of Social Sciences and Humanities"
        case "S002":
            schoolTextField.text = "University of Economics and Law"
        case "S003":
            schoolTextField.text = "University of Information Technology"
        default:
            break
        }
        emailTextField.text = "Email:    \(currentUser.string(forKey: "email")!)"
        switch (currentUser.integer(forKey: "isVerified")) {
        case 0:
            statusTextField.text = "Status:   Not Verified"
            verifiedAccountButton.isEnabled = true
            verifiedAccountButton.alpha = 1
        case 1:
            statusTextField.text = "Status:   Pending"
            verifiedAccountButton.isEnabled = false
            verifiedAccountButton.alpha = 0.5
        case 2:
            statusTextField.text = "Status:   Verified"
            verifiedAccountButton.isEnabled = false
            verifiedAccountButton.alpha = 0.5
        default:
            break
        }
    }
    
    @IBAction func verifiedAccountButtonTapped(_ sender: Any) {
        hud.show(in: self.view)
        db.collection("users").document(currentUser.string(forKey: "email")!).updateData(["isVerified":1]) { (error) in
            self.hud.dismiss()
            if let error = error {
                SCLAlertView().showError("Error", subTitle: error.localizedDescription)
            }
            else {
                self.fetchData()
            }
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        try! Auth.auth().signOut()
        let loginNavigationController = UIStoryboard.loginNavigationController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController!)
    }
    
    // MARK: - fetchData
    func fetchData() {
        hud.show(in: self.view)
        db.collection("users").document(currentUser.string(forKey: "email")!).getDocument { (snapshot, error) in
            self.hud.dismiss()
            if let error = error {
                SCLAlertView().showError("Error", subTitle: error.localizedDescription)
            }
            else {
                self.isFetched = true
                Utils.setUserDefaults(name: snapshot?.data()!["name"] as! String,
                                      schoolID: snapshot?.data()!["schoolID"] as! String,
                                      email: snapshot?.data()!["email"] as! String,
                                      uid: snapshot?.data()!["uid"] as! String,
                                      role: snapshot?.data()!["role"] as! Int,
                                      isVerified: snapshot?.data()!["isVerified"] as! Int)
                self.presentData()
            }
        }
    }
    
    
}
