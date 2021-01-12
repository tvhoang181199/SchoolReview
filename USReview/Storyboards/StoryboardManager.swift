//
//  StoryboardManager.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 03/01/2021.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func mainTabBarController() -> MainTabBarController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
    }
    
    class func loginNavigationController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LoginNavigationController")
    }
    
    class func loginViewController() -> LoginViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
    
    class func signUpViewController() -> SignUpViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
    }
    
    class func addPostViewController() -> AddPostViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "AddPostViewController") as? AddPostViewController
    }
    
    class func myPostsViewController() -> MyPostsViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MyPostsViewController") as? MyPostsViewController
    }
    
}
