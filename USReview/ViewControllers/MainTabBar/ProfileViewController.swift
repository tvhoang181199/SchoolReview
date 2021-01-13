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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var verifiedAccountButton: UIButton!
    @IBOutlet weak var myPostsButton: UIButton!
    @IBOutlet weak var myPostsButtonTopConstraint: NSLayoutConstraint!
    
    var currentUser = UserDefaults.standard
    var firestoreListener: ListenerRegistration? = nil
    
    let db = Firestore.firestore()
    
    let hud = JGProgressHUD(style:  .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupUI()
        
        if (currentUser.integer(forKey: "isVerified") == 2) {
            presentData()
        }
        else {
            fetchData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (firestoreListener != nil && currentUser.integer(forKey: "isVerified") == 2) {
            firestoreListener?.remove()
            firestoreListener = nil
            print("Removed Firestore listener")
        }
    }
    
    func _setupUI() {
        verifiedAccountButton.alpha = 1
        verifiedAccountButton.isEnabled = false
        myPostsButton.alpha = 0
        myPostsButton.isEnabled = false
        myPostsButtonTopConstraint.constant = -50
    }
    
    func presentData() {
        // Simple components
        nameLabel.text = currentUser.string(forKey: "name")
        emailLabel.text = "Email:    \(currentUser.string(forKey: "email")!)"
        
        // Hard code school name with schoolID
        switch (currentUser.string(forKey: "schoolID")!) {
        case "S000":
            schoolLabel.text = "University of Science"
        case "S001":
            schoolLabel.text = "University of Social Sciences and Humanities"
        case "S002":
            schoolLabel.text = "University of Economics and Law"
        case "S003":
            schoolLabel.text = "University of Information Technology"
        default:
            break
        }
        
        // Hard code user avatar with schoolID
        switch (currentUser.string(forKey: "schoolID")!) {
        case "S000":
            userImageView.image = UIImage(named: "HCMUS_avatar")
        case "S001":
            userImageView.image = UIImage(named: "HCMUSSH_avatar")
        case "S002":
            userImageView.image = UIImage(named: "UEL_avatar")
        case "S003":
            userImageView.image = UIImage(named: "UIT_avatar")
        default:
            break
        }
        
        switch (currentUser.integer(forKey: "isVerified")) {
        case 0:
            statusLabel.text = "Status:   Not Verified"
            verifiedAccountButton.isHidden = false
            verifiedAccountButton.isEnabled = true
            verifiedAccountButton.alpha = 1
            myPostsButton.isHidden = true
            myPostsButton.isEnabled = false
            myPostsButton.alpha = 0
            
        case 1:
            statusLabel.text = "Status:   Pending"
            verifiedAccountButton.isHidden = false
            verifiedAccountButton.isEnabled = false
            verifiedAccountButton.alpha = 0.8
            myPostsButton.isHidden = true
            myPostsButton.isEnabled = false
            myPostsButton.alpha = 0
        case 2:
            statusLabel.text = "Status:   Verified"
            verifiedAccountButton.isEnabled = false
            myPostsButton.isHidden = false
            myPostsButton.isEnabled = true
            if (firestoreListener != nil) {
                UIView.animate(withDuration: 0.24,
                               delay: 0,
                               options: .curveEaseOut) { [weak self] in
                    self?.verifiedAccountButton.alpha = 0
                } completion: { (value) in
                    UIView.animate(withDuration: 0.4,
                                   delay: 0,
                                   options: .curveEaseOut) { [weak self] in
                        self?.myPostsButton.alpha = 1
                    } completion: { (value) in
                    }
                }
            }
            else {
                verifiedAccountButton.alpha = 0
                myPostsButton.alpha = 1
            }

        default:
            break
        }
    }
    
    // MARK: - UIButton actions
    @IBAction func verifiedAccountButtonTapped(_ sender: Any) {
        hud.show(in: self.view)
        db.collection("users").document(currentUser.string(forKey: "email")!).updateData(["isVerified":1]) { (error) in
            self.hud.dismiss()
            if let error = error {
                SCLAlertView().showError("Error", subTitle: error.localizedDescription)
            }
            else {
                Toast.show(message: "Your request has been sent", controller: self)
            }
        }
        
    }
    
    @IBAction func myPostsButtonTapped(_ sender: Any) {
        let vc = UIStoryboard.myPostsViewController()
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        if let appDomain = Bundle.main.bundleIdentifier {
            currentUser.removePersistentDomain(forName: appDomain)
        }
        try! Auth.auth().signOut()
        let loginNavigationController = UIStoryboard.loginNavigationController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController!)
    }
    
    // MARK: - fetchData
    func fetchData() {
        firestoreListener = db.collection("users").document(currentUser.string(forKey: "email")!).addSnapshotListener { (snapshot, error) in
            if let error = error {
                Toast.show(message: error.localizedDescription, controller: self)
            }
            else {
                Utils.setUserDefaults(name: snapshot?.data()!["name"] as! String,
                                      schoolID: snapshot?.data()!["schoolID"] as! String,
                                      email: snapshot?.data()!["email"] as! String,
                                      userID: snapshot?.data()!["userID"] as! String,
                                      role: snapshot?.data()!["role"] as! Int,
                                      isVerified: snapshot?.data()!["isVerified"] as! Int)
                self.presentData()
            }
        }
    }
    
    
}
