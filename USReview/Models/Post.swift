//
//  Post.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 11/01/2021.
//

import Foundation

class Post {
    var postID: String? = ""
    var schoolID: String? = ""
    var userID: String? = ""
    var title: String? = ""
    var content: String? = ""
    var createdDay: Date? = nil
    
    init(){
    }
    
    init(postID: String?, schoolID: String?, userID: String?, title: String?, content: String?, createdDay: Date?) {
        self.postID = postID
        self.schoolID = schoolID
        self.userID = schoolID
        self.title = title
        self.content = content
        self.createdDay = createdDay
    }
    
    func setUser(postID: String?, schoolID: String?, userID: String?, title: String?, content: String?, createdDay: Date?) {
        self.postID = postID
        self.schoolID = schoolID
        self.userID = schoolID
        self.title = title
        self.content = content
        self.createdDay = createdDay
    }
}
