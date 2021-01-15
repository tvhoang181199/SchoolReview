//
//  User.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 11/01/2021.
//

import Foundation

class User {
    var name: String? = ""
    var schoolID: String? = ""
    var email: String? = ""
    var userID: String? = ""
    var isVerified: Int? = 0
    var role: Int? = 0
    
    init(){
    }
    
    init(name: String?, schoolID: String?, email: String?, userID: String?, isVerified: Int?, role: Int?){
        self.name = name
        self.schoolID = schoolID
        self.email = email
        self.userID = userID
        self.isVerified = isVerified
        self.role = role
    }
    
    func setUser(name: String?, schoolID: String?, email: String?, userID: String?, isVerified: Int?, role: Int?) {
        self.name = name
        self.schoolID = schoolID
        self.email = email
        self.userID = userID
        self.isVerified = isVerified
        self.role = role
    }
}
