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
                    self.hud.dismiss()
                    
                    // Set data for after login flow
                    UserDefaults.standard.set(snapshot?.data()!["name"] as? String, forKey: "name")
                    UserDefaults.standard.set(snapshot?.data()!["email"] as? String, forKey: "email")
                    UserDefaults.standard.set(snapshot?.data()!["schoolID"] as? String, forKey: "schoolID")
                    UserDefaults.standard.set(snapshot?.data()!["uid"] as? String, forKey: "uid")
                    UserDefaults.standard.set(snapshot?.data()!["isVerified"] as? Int, forKey: "isVerified")
                    UserDefaults.standard.set(snapshot?.data()!["role"] as? Int, forKey: "role")
                    
                    // Change root view to main tab bar
                    let mainTabBarController = UIStoryboard.mainTabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController!)
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
