//
//  School.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 11/01/2021.
//

import UIKit

class School {
    
    var schoolID: String? = ""
    var fullName: String? = ""
    var shortName: String? = ""
    var localtion: String? = ""
    var image: UIImage? = nil
    
    init(){
    }
    
    init(schoolID:String?, fullName:String?, shortName:String?, localtion: String?, image:UIImage?){
        self.schoolID = schoolID
        self.fullName = fullName
        self.shortName = shortName
        self.localtion = localtion
        self.image = image
    }
    
    func setUser(schoolID:String?, fullName:String?, shortName:String?, localtion: String?, image:UIImage?) {
        self.schoolID = schoolID
        self.fullName = fullName
        self.shortName = shortName
        self.localtion = localtion
        self.image = image
    }
}
