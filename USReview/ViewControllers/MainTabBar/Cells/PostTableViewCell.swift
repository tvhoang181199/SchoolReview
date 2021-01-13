//
//  PostTableViewCell.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 12/01/2021.
//

import UIKit

import FirebaseFirestore

protocol PostCellProtocol {
    func editPostDidTapped(_ data: Post)
    func callBackError(_ error: Error)
}

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTextFieldTopConstraint: NSLayoutConstraint!
    
    var delegate: PostCellProtocol!
    var postData: Post? = nil
    
    // Quick access properties
    let db = Firestore.firestore()
    let currentUser = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setPost(_ post:Post) {
        commentTextFieldTopConstraint.constant = 15
        
        // Prepare data for edit
        postData = post
        
        // Simple components
        userNameLabel.text = post.userName
        postTitleLabel.text = post.title
        postContentLabel.text = post.content
        // formatter for createdDate
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy 'at' HH:mm"
        createdDateLabel.text = formatter.string(from: post.createdDate!.dateValue())
        likesCountLabel.text = Utils.suffixNumber(number: post.likes!)
        
        // Hard code school image
        switch post.schoolID {
        case "S000":
            schoolImageView.image = UIImage(named: "HCMUS")
        case "S001":
            schoolImageView.image = UIImage(named: "HCMUSSH")
        case "S002":
            schoolImageView.image = UIImage(named: "UEL")
        case "S003":
            schoolImageView.image = UIImage(named: "UIT")
        default:
            break
        }
        
        // Hard code avatar image
        switch post.schoolID {
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
        
        // Status
        if (post.isVerified! == true) {
            statusLabel.isHidden = true
        }
        else {
            statusLabel.isHidden = false
            statusLabel.text = "Pending"
        }
        
        // Like status
        if (post.isCurrentUserLikedPost()) {
            likeButton.isSelected = true
        }
        else {
            likeButton.isSelected = false
        }
        
        // Comments
        presentComments(post)
        
    }
    
    func presentComments(_ post:Post) {
        commentsStackView.removeAllArrangedSubviews()
        for i in 0..<(post.comments?.count ?? 0) {
            // Comments exists
            commentTextFieldTopConstraint.constant = 0
            
            // Create comment row
            let container = UIView()
            let commentImageView = UIImageView()
            let commentUserNameLabel = UILabel()
            let commentContentLabel = UILabel()
            
            // Add to container
            container.addSubview(commentImageView)
            container.addSubview(commentUserNameLabel)
            container.addSubview(commentContentLabel)
            
            // Auto layout
            container.translatesAutoresizingMaskIntoConstraints = false
            commentImageView.translatesAutoresizingMaskIntoConstraints = false
            commentUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
            commentContentLabel.translatesAutoresizingMaskIntoConstraints = false
            
            container.widthAnchor.constraint(equalToConstant: commentsStackView.superview!.bounds.size.width).isActive = true
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true
            
            commentImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
            commentImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15).isActive = true
            commentImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
            commentImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            commentUserNameLabel.leadingAnchor.constraint(equalTo: commentImageView.trailingAnchor, constant: 5).isActive = true
            commentUserNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
            commentUserNameLabel.topAnchor.constraint(equalTo: commentImageView.topAnchor, constant: 3).isActive = true
//            commentUserNameLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
            
            commentContentLabel.leadingAnchor.constraint(equalTo: commentImageView.trailingAnchor, constant: 5).isActive = true
            commentContentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
            commentContentLabel.topAnchor.constraint(equalTo: commentUserNameLabel.bottomAnchor, constant: 0).isActive = true
            commentContentLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -10).isActive = true
            
            // Set data
            commentImageView.contentMode = .scaleAspectFit
            commentImageView.layer.cornerRadius = commentImageView.bounds.size.width/2
            switch post.comments![i]["schoolID"] as? String {
            case "S000":
                commentImageView.image = UIImage(named: "HCMUS_avatar")
            case "S001":
                commentImageView.image = UIImage(named: "HCMUSSH_avatar")
            case "S002":
                commentImageView.image = UIImage(named: "UEL_avatar")
            case "S003":
                commentImageView.image = UIImage(named: "UIT_avatar")
            default:
                break
            }
            
            commentUserNameLabel.numberOfLines = 1
            commentUserNameLabel.font = UIFont(name: "GillSans-Bold", size: 15)
            commentUserNameLabel.text = post.comments![i]["userName"] as? String
            
            commentContentLabel.numberOfLines = 0
            commentContentLabel.lineBreakMode = .byWordWrapping
            commentContentLabel.font = UIFont(name: "GillSans", size: 14)
            commentContentLabel.text = post.comments![i]["content"] as? String

            commentsStackView.addArrangedSubview(container)
        }
        
    }
    
    // MARK: - Button actions

    @IBAction func starButtonTapped(_ sender: Any) {
        if (likeButton.isSelected == false) {
            likeButton.isEnabled = false
            db.collection("posts").document((postData?.postID)!).updateData(["likedUsers":[
                                                                                currentUser.string(forKey: "userID"):true],
                                                                             "likes": ((postData?.likes)!+1)
            ]) { (error) in
                if let error = error {
                    self.delegate.callBackError(error)
                }
                else {
                    self.likeButton.isEnabled = true
                }
            }
        }
        else if (likeButton.isSelected == true) {
            likeButton.isEnabled = false
            db.collection("posts").document((postData?.postID)!).updateData(["likedUsers":[
                                                                                currentUser.string(forKey: "userID"):false],
                                                                             "likes": ((postData?.likes)!-1)
            ]) { (error) in
                if let error = error {
                    self.delegate.callBackError(error)
                }
                else {
                    self.likeButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.delegate.editPostDidTapped(postData!)
    }
    
    @IBAction func sendCommentTapped(_ sender: Any) {
        if (commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            db.collection("posts").document((postData?.postID)!).updateData(["comments":FieldValue.arrayUnion([[
                "userID": currentUser.string(forKey: "userID")!,
                "userName": currentUser.string(forKey: "name")!,
                "schoolID": currentUser.string(forKey: "schoolID")!,
                "content": commentTextField.text!,
                "createdAt": Date()
            ]])
            ]) { (error) in
                if let error = error {
                    self.delegate.callBackError(error)
                }
                else {
                    // do something that i still dont know :))
                }
            }
        }
        commentTextField.text = ""
        commentTextField.resignFirstResponder()
    }
    
}
