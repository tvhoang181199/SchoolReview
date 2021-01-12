//
//  Post.swift
//  USReview
//
//  Created by Trịnh Vũ Hoàng on 11/01/2021.
//

import Foundation

import FirebaseFirestore

class Post {
    var postID: String? = ""
    var schoolID: String? = ""
    var userID: String? = ""
    var userName: String? = ""
    var title: String? = ""
    var content: String? = ""
    var like: Int? = 0
    var isVerified: Bool? = false
    var createdDate: Date? = nil
    
    init(postID: String?, schoolID: String?, userID: String?, userName: String?, title: String?, content: String?, like: Int?, isVerified: Bool?, createdDate: Date?) {
        self.postID = postID
        self.schoolID = schoolID
        self.userID = schoolID
        self.userName = userName
        self.title = title
        self.content = content
        self.like = like
        self.isVerified = isVerified
        self.createdDate = createdDate
    }
    
    init(_ post: Post) {
        self.postID = post.postID
        self.schoolID = post.schoolID
        self.userID = post.schoolID
        self.userName = post.userName
        self.title = post.title
        self.content = post.content
        self.like = post.like
        self.isVerified = post.isVerified
        self.createdDate = post.createdDate
    }
    
    init(_ snapshotData: DocumentSnapshot){
        self.postID = snapshotData.data()!["postID"] as? String
        self.schoolID = snapshotData.data()!["schoolID"] as? String
        self.userID = snapshotData.data()!["userID"] as? String
        self.userName = snapshotData.data()!["userName"] as? String
        self.title = snapshotData.data()!["title"] as? String
        self.content = snapshotData.data()!["content"] as? String
        self.like = snapshotData.data()!["like"] as? Int
        self.isVerified = snapshotData.data()!["isVerified"] as? Bool
        self.createdDate = snapshotData.data()!["createdDate"] as? Date
    }
    
    func setPost(postID: String?, schoolID: String?, userID: String?, userName: String?, title: String?, content: String?, like: Int?, isVerified: Bool?, createdDate: Date?) {
        self.postID = postID
        self.schoolID = schoolID
        self.userID = schoolID
        self.userName = userName
        self.title = title
        self.content = content
        self.like = like
        self.isVerified = isVerified
        self.createdDate = createdDate
    }
    
    func setPostWithPost(_ post: Post) {
        self.postID = post.postID
        self.schoolID = post.schoolID
        self.userID = post.schoolID
        self.userName = post.userName
        self.title = post.title
        self.content = post.content
        self.like = post.like
        self.isVerified = post.isVerified
        self.createdDate = post.createdDate
    }
    
    func setPostWithSnapshotData(_ snapshotData: DocumentSnapshot) {
        self.postID = snapshotData.data()!["postID"] as? String
        self.schoolID = snapshotData.data()!["schoolID"] as? String
        self.userID = snapshotData.data()!["userID"] as? String
        self.userName = snapshotData.data()!["userName"] as? String
        self.title = snapshotData.data()!["title"] as? String
        self.content = snapshotData.data()!["content"] as? String
        self.like = snapshotData.data()!["like"] as? Int
        self.isVerified = snapshotData.data()!["isVerified"] as? Bool
        self.createdDate = snapshotData.data()!["createdDate"] as? Date
    }
}
