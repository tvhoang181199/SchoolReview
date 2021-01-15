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
    
    static func suffixNumber(number: Int) -> String {
        var num: Double = Double(number)
        let sign = ((num < 0) ? "-" : "" )

        num = fabs(num)

        if (num < 1000.0){
            return String(format: "%@%.0f", sign, num)
        }

        let exp: Int = Int(log10(num) / 3.0 )

        let units: [String] = ["K","M","B"]

        let roundedNum: Double = round(10 * num / pow(1000.0,Double(exp))) / 10

        return "\(sign)\(roundedNum)\(units[exp-1])"
    }
}
