//
//  User.swift
//  SuperMessenger
//
//  Created by admin on 05/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import Firebase

class UserInfo {
    
    var userUID : String
    var email : String
    var fullName : String
    var status : String
    var profileImageUrl : String?
    
    init(_userUID:String, _email:String, _fullName:String, _profileImageUrl:String?) {
        userUID = _userUID
        fullName = _fullName
        email = _email
        profileImageUrl = _profileImageUrl
        status = ""
    }
    
    init(_uid:String, json:[String:Any]) {
        userUID = _uid
        fullName = json["fullName"] as! String
        email = json["email"] as! String
        profileImageUrl = json["email"] as? String
        status = json["email"] as! String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        
        json["fullName"] = fullName
        json["email"] = email
        json["profileImageUrl"] = profileImageUrl
        json["status"] = status
        
        return json
    }
    
//    func save(){
//        IJProgressView.shared.showProgressView()
//        let ref = Database.database().reference()
//        let userref = ref.child("users").child(userUID)
//        userref.setValue(["email" : Email, "fullName" : FullName, "status" : Status])
//
//        let storageRef = Storage.storage().reference()
//        let userImageRef = storageRef.child("ProfileImages/\(userUID).png")
//
//        if let uploadData = ProfileImage.pngData(){
//            userImageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print(error as Any)
//                    IJProgressView.shared.hideProgressView()
//                }else{
//                    IJProgressView.shared.hideProgressView()
//                }
//            }
//        }
//    }
    
    
}

