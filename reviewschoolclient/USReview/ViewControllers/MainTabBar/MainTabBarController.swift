//
//  MainTabbarController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 10/01/2021.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

import SCLAlertView

class MainTabBarController: UITabBarController {
    
    // Quick access properties
    let currentUser = UserDefaults.standard
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupCenterButton()
        
        backgroundCheckAccountStatus()
    }

    func setupCenterButton() {
        let addButton = UIButton(frame: CGRect(x: self.tabBar.frame.size.width/2 - 25, y: -25, width: 50, height: 50))
        addButton.backgroundColor = UIColor.white
        addButton.layer.cornerRadius = 25
        
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = UIColor.init(red: 42/255, green: 51/255, blue: 66/255, alpha: 1)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.imageEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
        self.tabBar.addSubview(addButton)
        view.layoutIfNeeded()
    }


    // MARK: - Actions
    @objc private func addButtonTapped(sender: UIButton) {
        if (currentUser.integer(forKey: "isVerified") != 2) {
            SCLAlertView().showWarning("Verification Warning", subTitle: "Please verify your account to access this feature")
        }
        else {
            let vc = UIStoryboard.addPostViewController()
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    // MARK: - Background check account status
    func backgroundCheckAccountStatus() {
        db.collection("users").document(currentUser.string(forKey: "email")!).addSnapshotListener { (snapshot, error) in
            if let error = error {
                Toast.show(message: error.localizedDescription, controller: self)
            }
            else {
                print("Check account blocked listener is in background...")
                if ((snapshot?.data()!["isBlocked"] as? Bool) == true) {
                    if let appDomain = Bundle.main.bundleIdentifier {
                        self.currentUser.removePersistentDomain(forName: appDomain)
                        try! Auth.auth().signOut()
                    }
                    
                    let topMostVC = UIApplication.getTopMostViewController()!
                    if (topMostVC == self) {
                        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                        alertView.addButton("OK") {
                            let loginNavigationController = UIStoryboard.loginNavigationController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController!)
                        }
                        alertView.showWarning("Warning", subTitle: "Your account has been blocked by admin. Your session has been stopped.")
                    }
                    else {
                        NotificationCenter.default.post(name: Notification.Name("UserWasBlocked"), object: nil)
                    }
                    
                }
            }
        }
    }

}
