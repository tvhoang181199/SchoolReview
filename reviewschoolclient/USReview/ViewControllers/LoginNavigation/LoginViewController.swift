//
//  LoginViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 02/01/2021.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

import JGProgressHUD
import SCLAlertView

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let hud = JGProgressHUD(style: .dark)
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
    
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.dismissKeyboard()
        
        hud.textLabel.text = "Logging in..."
        hud.show(in: self.view)
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.hud.dismiss()
                Toast.show(message: error!.localizedDescription, controller: self)
            }
            else {
                self.db.collection("users").document(email).getDocument { (snapshot, error) in
                    if let error = error {
                        self.hud.dismiss()
                        Toast.show(message: error.localizedDescription, controller: self)
                    }
                    else {
                        self.hud.dismiss()
                        
                        // If user has been blocked
                        if ((snapshot?.data()!["isBlocked"] as? Bool) == true) {
                            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                            alertView.addButton("OK") {
                            }
                            alertView.showError("Error", subTitle: "Your account has been blocked by admin. Please contact admin for more information.")
                        }
                        else {
                            // Set data for after login flow                            
                            Utils.setUserDefaults(name: snapshot?.data()!["name"] as! String,
                                                  schoolID: snapshot?.data()!["schoolID"] as! String,
                                                  email: snapshot?.data()!["email"] as! String,
                                                  userID: snapshot?.data()!["userID"] as! String,
                                                  role: snapshot?.data()!["role"] as! Int,
                                                  isVerified: snapshot?.data()!["isVerified"] as! Int)
                            
                            // Change root view to main tab bar
                            let mainTabBarController = UIStoryboard.mainTabBarController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController!)
                        }
                    }
                }
            }
        }  
    }
    
    // MARK: - UITextFieldDelegate
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1
        
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
}
