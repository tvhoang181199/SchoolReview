//
//  PostTableViewCell.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 12/01/2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var schoolImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setPost(_ post:Post) {
        userNameLabel.text = post.userName
        postTitleLabel.text = post.title
        postContentLabel.text = post.content
        switch post.schoolID {
        case "S001":
            schoolImageView.image = UIImage(named: "HCMUS")
        case "S002":
            schoolImageView.image = UIImage(named: "HCMUSSH")
        case "S003":
            schoolImageView.image = UIImage(named: "UEL")
        case "S004":
            schoolImageView.image = UIImage(named: "UIT")
        default:
            break
        }
        
        // formatter for createdDate
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, dd/MM/yyyy"
        createdDateLabel.text = formatter.string(from: post.createdDate!.dateValue())
    }

}
