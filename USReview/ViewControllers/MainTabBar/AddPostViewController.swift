//
//  AddPostViewController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 10/01/2021.
//

import UIKit

import FirebaseFirestore

import JGProgressHUD

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    let db = Firestore.firestore()
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        contentTextView.text = "Content"
        contentTextView.textColor = UIColor.systemGray4
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        hud.textLabel.text = "Posting..."
        hud.show(in: self.view)
        db.collection("posts").document("")
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
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Content"
            textView.textColor = UIColor.systemGray4
        }
    }
}
