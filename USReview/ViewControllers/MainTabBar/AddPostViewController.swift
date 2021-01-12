//
//  AddPostViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 10/01/2021.
//

import UIKit

import FirebaseFirestore

import SCLAlertView
import JGProgressHUD

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    
    var layoutGuide = UILayoutGuide()
    var safeViewHeight: CGFloat = 0
    var keyboardHeight: CGFloat = 0
    
    let db = Firestore.firestore()
    let currentUser = UserDefaults.standard
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        contentTextView.text = "Content"
        contentTextView.textColor = UIColor.systemGray4
        
        layoutGuide = view.safeAreaLayoutGuide
        safeViewHeight = layoutGuide.layoutFrame.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
    
    // MARK: - UIButton actions
    @IBAction func postButtonTapped(_ sender: Any) {
        if (titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                (contentTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "Content" &&
                    contentTextView.textColor == UIColor.systemGray4)) {
            Toast.show(message: "Please fill Title and Content", controller: self)
        }
        else {
            hud.textLabel.text = "Posting..."
            hud.show(in: self.view)
            
            // Create an unique id
            let postID = UUID().uuidString
            
            let dispatchGroup = DispatchGroup()
            
            // Create post in myposts collection
            dispatchGroup.enter()
            db.collection("myposts").document(currentUser.string(forKey: "email")!).updateData([postID: titleTextField.text!
            ]) { (error) in
                if let error = error {
                    self.hud.dismiss()
                    Toast.show(message: error.localizedDescription, controller: self)
                }
                dispatchGroup.leave()
            }
            
            //Create post in posts
            dispatchGroup.enter()
            db.collection("posts").document(postID).setData(["postID": postID,
                                                             "schoolID": currentUser.string(forKey: "schoolID")!,
                                                             "userID": currentUser.string(forKey: "userID")!,
                                                             "title": titleTextField.text!,
                                                             "content": contentTextView.text!,
                                                             "like": 0,
                                                             "isVerified": false,
                                                             "createdDate": Date()
            ]) { (error) in
                if let error = error {
                    self.hud.dismiss()
                    Toast.show(message: error.localizedDescription, controller: self)
                }
                dispatchGroup.leave()
            }
            
            // Dismiss and alert
            dispatchGroup.notify(queue: .main) {
                self.hud.dismiss()
                self.presentingViewController?.dismiss(animated: true, completion: {
                    let vc = UIApplication.getTopMostViewController()!
                    Toast.show(message: "Your post has been created", controller: vc)
                })
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - textView Protocols
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.systemGray4) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        contentViewBottom.constant = 15 + keyboardHeight
        containerHeight.constant = safeViewHeight - 50 + keyboardHeight
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Content"
            textView.textColor = UIColor.systemGray4
        }
        contentViewBottom.constant = 15
        containerHeight.constant = safeViewHeight - 50
    }
}
