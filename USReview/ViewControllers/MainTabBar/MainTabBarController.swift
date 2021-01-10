//
//  MainTabbarController.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 10/01/2021.
//

import UIKit

class MainTabBarController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()


        setupMiddleButton()
    }

    func setupMiddleButton() {
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        var addButtonFrame = addButton.frame
        addButtonFrame.origin.y = view.bounds.height - 49 - addButtonFrame.size.height/2
        addButtonFrame.origin.x = view.bounds.width/2 - addButtonFrame.size.width/2
        addButton.frame = addButtonFrame

        addButton.backgroundColor = UIColor.white
        addButton.layer.cornerRadius = addButtonFrame.height/2
        view.addSubview(addButton)

        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = UIColor.init(red: 42/255, green: 51/255, blue: 66/255, alpha: 1)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.imageEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }


    // MARK: - Actions
    @objc private func addButtonTapped(sender: UIButton) {
        let vc = UIStoryboard.addPostViewController()
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }

}
