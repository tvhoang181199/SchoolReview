//
//  SignUpViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 02/01/2021.
//

import UIKit
import JGProgressHUD
import Firebase

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let hud = JGProgressHUD(style: .dark)
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.init(red: 42/255, green: 51/255, blue: 66/255, alpha: 1),
             NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 20)!]
    }
    
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            schoolTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: "Please fill all information!", controller: self)
            return
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let md5PasswordData = MD5(string:cleanedPassword)
        let md5Base64Password = md5PasswordData.base64EncodedString()
        
        if Utils.isPasswordValid(cleanedPassword) == false {
            Toast.show(message: "Please make sure that password has at least 8 characters!", controller: self)
            return
        }
        
        hud.textLabel.text = "Creating an account..."
        hud.show(in: self.view)
        
        Auth.auth().createUser(withEmail: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (result, err) in
            if err != nil {
                Toast.show(message: "Error creating user!", controller: self)
                self.hud.dismiss()
            }
            else {
                self.db.collection("users").document(self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)).setData([
                    "name":self.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    "school":self.schoolTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    "gender":self.genderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    "email":self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    "password":md5Base64Password,
                    "uid":result!.user.uid
                ]) { (error) in
                    if error != nil {
                        self.hud.dismiss()
                        Toast.show(message: "Error saving user!", controller: self)
                    }
                    else {
                        self.hud.dismiss()
                        let mainTabBarController = UIStoryboard.mainTabbarController()
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController!)
                    }
                }
            }
        }
    }
    
}
