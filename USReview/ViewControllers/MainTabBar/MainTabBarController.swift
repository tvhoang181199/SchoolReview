//
//  MainTabbarController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 10/01/2021.
//

import UIKit

import SCLAlertView

class MainTabBarController: UITabBarController {
    
    let currentUser = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMiddleButton()
    }

    func setupMiddleButton() {
        let addButton = UIButton(frame: CGRect(x: self.tabBar.frame.size.width/2 - 25, y: -25, width: 50, height: 50))
        addButton.backgroundColor = UIColor.white
        addButton.layer.cornerRadius = 25
        
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = UIColor.init(red: 42/255, green: 51/255, blue: 66/255, alpha: 1)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.imageEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
        self.tabBar.addSubview(addButton)
        view.layoutIfNeeded()
    }


    // MARK: - Actions
    @objc private func addButtonTapped(sender: UIButton) {
        if (currentUser.integer(forKey: "isVerified") != 2) {
            SCLAlertView().showWarning("Verification Warning", subTitle: "Please verify your account to access this feature")
        }
        else {
            let vc = UIStoryboard.addPostViewController()
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }

}
