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
}
