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
    
    class func loginViewController() -> LoginViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
    
    class func signUpViewController() -> SignUpViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
    }
    
    class func mainTabbarController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainTabbarController")
    }
    
    class func loginNavigationController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LoginNavigationController")
    }
    
}
