//
//  SignUpViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 02/01/2021.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

import JGProgressHUD

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class SignUpViewController: UIViewController, UITextFieldDelegate,  UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let hud = JGProgressHUD(style: .dark)
    let db = Firestore.firestore()
    
    var schoolID: String? = ""

    let schoolList = ["University of Science",
                      "University of Social Sciences and Humanities",
                      "University of Economics and Law",
                      "University of Information Technology"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.tag = 0
        schoolTextField.tag = 1
        emailTextField.tag = 2
        passwordTextField.tag = 3
        
        nameTextField.delegate = self
        schoolTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        self.dismissKeyboard()
        
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            schoolTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
                self.hud.dismiss()
                Toast.show(message: "Error creating user!", controller: self)
            }
            else {
                let dispatchGroup = DispatchGroup()
                
                // Set data to mypost collection
                dispatchGroup.enter()
                self.db.collection("myposts").document(self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)).setData([:]) { (error) in
                    if error != nil {
                        self.hud.dismiss()
                        Toast.show(message: "Error saving user!", controller: self)
                    }
                    dispatchGroup.leave()
                }
                
                // Set data to users collection
                dispatchGroup.enter()
                self.db.collection("users").document(self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)).setData([
                    "name":self.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    "schoolID":self.schoolID!,
                    "email":self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    "password":md5Base64Password,
                    "isVerified": 0,
                    "role": 0,
                    "userID":result!.user.uid
                ]) { (error) in
                    if error != nil {
                        self.hud.dismiss()
                        Toast.show(message: "Error saving user!", controller: self)
                    }
                    dispatchGroup.leave()
                }
                
                // Change to main tab bar and alert
                dispatchGroup.notify(queue: .main) {
                    self.hud.dismiss()
                    
                    // Set data for after login flow
                    UserDefaults.standard.set(self.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "name")
                    UserDefaults.standard.set(self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
                    UserDefaults.standard.set(self.schoolID!, forKey: "schoolID")
                    UserDefaults.standard.set(result!.user.uid, forKey: "userID")
                    UserDefaults.standard.set(0, forKey: "isVerified")
                    UserDefaults.standard.set(0, forKey: "role")
                    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 1) {
            let picker = UIPickerView()
            picker.delegate = self
            textField.inputView = picker
            picker.selectRow(0, inComponent: 0, animated: true)
            schoolID = "S000"
            textField.text = schoolList[0]
        }
    }
    
    // UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schoolList.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schoolList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        schoolTextField.text = schoolList[row]
        schoolID = "S00\(row)"
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        schoolTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
}

