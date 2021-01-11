//
//  Utils.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 03/01/2021.
//

import UIKit
import Foundation

class Utils: NSObject {
    
    static func isPasswordValid(_ password : String) -> Bool {
        return (password.count<8) ? false : true
    }
    
    static func setUserDefaults(name: String, schoolID: String, email: String, userID: String, role: Int, isVerified:Int) {
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(schoolID, forKey: "schoolID")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(userID, forKey: "userID")
        UserDefaults.standard.set(role, forKey: "role")
        UserDefaults.standard.set(isVerified, forKey: "isVerified")
    }
}
