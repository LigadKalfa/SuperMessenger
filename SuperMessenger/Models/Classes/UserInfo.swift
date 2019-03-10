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
    var profileImage : UIImage?
    
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
        profileImageUrl = json["profileImageUrl"] as? String
        status = json["status"] as! String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        
        json["fullName"] = fullName
        json["email"] = email
        json["profileImageUrl"] = profileImageUrl
        json["status"] = status
        
        return json
    }
}

