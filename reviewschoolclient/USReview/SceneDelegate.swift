//
//  SceneDelegate.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 01/01/2021.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        window.rootViewController = vc
        
        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        if (Auth.auth().currentUser != nil && UserDefaults.standard.string(forKey: "userID") != nil) {
            let mainTabBarController = UIStoryboard.mainTabBarController()
            window?.rootViewController = mainTabBarController
        }
        else {
            let loginNavigationController = UIStoryboard.loginNavigationController()
            window?.rootViewController = loginNavigationController
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

