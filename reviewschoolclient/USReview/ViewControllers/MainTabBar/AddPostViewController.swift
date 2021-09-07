//
//  AddPostViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 10/01/2021.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

import SCLAlertView
import JGProgressHUD

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonHeightConstraint: NSLayoutConstraint!
    
    var layoutGuide = UILayoutGuide()
    var safeViewHeight: CGFloat = 0
    var keyboardHeight: CGFloat = 0
    
    // Quick access properties
    let db = Firestore.firestore()
    let currentUser = UserDefaults.standard
    let hud = JGProgressHUD(style: .dark)
    
    // Data in editting flow
    var postData: Post? = nil
    var titleString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (titleString != nil) {
            titleLabel.text = titleString
            titleTextField.text = postData?.title
            contentTextView.textColor = UIColor.black
            contentTextView.text = postData?.content
            postButton.setTitle("Update", for: .normal)
            deleteButton.isHidden = false
            deleteButtonHeightConstraint.constant = 50
            deleteButtonBottomConstraint.constant = 15
        }
        else {
            contentTextView.delegate = self
            contentTextView.text = "Content"
            contentTextView.textColor = UIColor.systemGray4
            deleteButton.isHidden = true
            deleteButtonHeightConstraint.constant = 0
            deleteButtonBottomConstraint.constant = 5
        }
        
        layoutGuide = view.safeAreaLayoutGuide
        safeViewHeight = layoutGuide.layoutFrame.size.height
        
        // Observe keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Observe user was blocked or not
        NotificationCenter.default.addObserver(self, selector: #selector(userWasBlocked(notification:)), name: Notification.Name("UserWasBlocked"), object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
        contentViewBottomConstraint.constant = 15 + keyboardHeight
        containerHeightConstraint.constant = safeViewHeight - 50 + keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        contentViewBottomConstraint.constant = 15
        containerHeightConstraint.constant = safeViewHeight - 50
    }
    
    @objc func userWasBlocked(notification: NSNotification) {
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
    
    // MARK: - UIButton actions
    @IBAction func postButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        if (titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                (contentTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "Content" &&
                    contentTextView.textColor == UIColor.systemGray4)) {
            Toast.show(message: "Please fill Title and Content", controller: self)
        }
        else {
            // Posting
            if (titleString == nil && postData == nil) {
                hud.textLabel.text = "Posting..."
                hud.show(in: self.view)
                
                // Create an unique id
                let postID = UUID().uuidString
                
                //Create post in posts
                db.collection("posts").document(postID).setData(["postID": postID,
                                                                 "schoolID": currentUser.string(forKey: "schoolID")!,
                                                                 "userID": currentUser.string(forKey: "userID")!,
                                                                 "userName": currentUser.string(forKey: "name")!,
                                                                 "title": titleTextField.text!,
                                                                 "content": contentTextView.text!,
                                                                 "likes": 0,
                                                                 "isVerified": false,
                                                                 "createdDate": Date()
                ]) { (error) in
                    if let error = error {
                        self.hud.dismiss()
                        Toast.show(message: error.localizedDescription, controller: self)
                    }
                    else {
                        self.hud.dismiss()
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            let vc = UIApplication.getTopMostViewController()!
                            Toast.show(message: "Your post has been created", controller: vc)
                        })
                    }
                }
            }
            // Updating
            else {
                hud.textLabel.text = "Updating..."
                hud.show(in: self.view)
                
                //Create post in posts
                db.collection("posts").document((postData?.postID)!).updateData(["title": titleTextField.text!,
                                                                                 "content": contentTextView.text!,
                                                                                 "isVerified": false
                ]) { (error) in
                    if let error = error {
                        self.hud.dismiss()
                        Toast.show(message: error.localizedDescription, controller: self)
                    }
                    else {
                        self.hud.dismiss()
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            let vc = UIApplication.getTopMostViewController()!
                            Toast.show(message: "Your post has been updated. Please wait for verify.", controller: vc)
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()

        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alertView.addButton("Yes") {
            self.hud.textLabel.text = "Deleting..."
            self.hud.show(in: self.view)
            
            self.db.collection("posts").document((self.postData?.postID)!).delete { (error) in
                if let error = error {
                    self.hud.dismiss()
                    Toast.show(message: error.localizedDescription, controller: self)
                }
                else {
                    self.hud.dismiss()
                    self.presentingViewController?.dismiss(animated: true, completion: {
                        let vc = UIApplication.getTopMostViewController()!
                        Toast.show(message: "Your post has been deleted", controller: vc)
                    })
                }
            }
        }
        alertView.addButton("No") {
        }
        alertView.showWarning("Warning", subTitle: "Your post will be deleted permanently. Are you sure?")
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        if (titleTextField.text == "" && contentTextView.textColor == UIColor.systemGray4 && contentTextView.text == "Content") {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            alertView.addButton("Yes") {
                self.dismiss(animated: true, completion: nil)
            }
            alertView.addButton("No") {
            }
            alertView.showWarning("Warning", subTitle: "Your post has not been saved. Are you sure?")
        }
    }
    
    // MARK: - textView Protocols
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.systemGray4) {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.tintColor = UIColor.init(red: 42/255, green: 51/255, blue: 66/255, alpha: 1)
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Content"
            textView.textColor = UIColor.systemGray4
            textView.tintColor = UIColor.init(red: 42/255, green: 51/255, blue: 66/255, alpha: 1)
        }

    }
}
