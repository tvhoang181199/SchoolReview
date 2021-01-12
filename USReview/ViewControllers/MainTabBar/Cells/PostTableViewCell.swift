//
//  PostTableViewCell.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 12/01/2021.
//

import UIKit

protocol EditPostProtocol {
    func editPostDidTapped(_ data: Post)
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
    @IBOutlet weak var starBottomSplitLine: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var delegate: EditPostProtocol!
    var postData: Post? = nil
    
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
        
        starBottomSplitLine.isHidden = true
        
    }

    @IBAction func starButtonTapped(_ sender: Any) {
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.delegate.editPostDidTapped(postData!)
    }
    
}
