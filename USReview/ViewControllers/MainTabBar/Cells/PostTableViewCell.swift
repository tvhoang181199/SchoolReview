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
        
    }

    @IBAction func starButtonTapped(_ sender: Any) {
        if (likeButton.isSelected == false) {
            db.collection("posts").document((postData?.postID)!).updateData(["likedUsers":[
                                                                                currentUser.string(forKey: "userID"):true],
                                                                             "likes": ((postData?.likes)!+1)
            ]) { (error) in
                if let error = error {
                    self.delegate.callBackError(error)
                }
                else {
                    self.likeButton.isSelected = true
                }
            }
        }
        else if (likeButton.isSelected == true) {
            db.collection("posts").document((postData?.postID)!).updateData(["likedUsers":[
                                                                                currentUser.string(forKey: "userID"):false],
                                                                             "likes": ((postData?.likes)!-1)
            ]) { (error) in
                if let error = error {
                    self.delegate.callBackError(error)
                }
                else {
                    self.likeButton.isSelected = false
                }
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.delegate.editPostDidTapped(postData!)
    }
    
}
