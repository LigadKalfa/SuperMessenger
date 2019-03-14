//
//  GlobalVariables.swift
//  SuperMessenger
//
//  Created by admin on 06/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//
import Foundation

struct SystemUser {
    static var currentUser : UserInfo?
    static var userFriends  = [UserInfo]()
    static var userSentedFriendRequest = [UserInfo]()
    static var userFriendRequest = [UserInfo]()
    
    static func setCurrUserInfo(_ callback:@escaping (Bool)->Void){
        if currentUser == nil {
            IJProgressView.shared.showProgressView()
            MainModel.instance.getUserInfo(MainModel.instance.currentUser()!.uid, callback: {(userInfo:UserInfo?) in
                if let user = userInfo {
                    SystemUser.currentUser = user
                    IJProgressView.shared.hideProgressView()
                    callback(true)
                }else{
                    IJProgressView.shared.hideProgressView()
                    callback(false)
                }
            })
        }else{
            callback(true)
        }
    }
    
    static func setUserFriendRequest(_ callback:@escaping (Bool)->Void){
        MainModel.instance.getRequestUsersInfo(callback: {(users:[UserInfo]?) in
            if let allUsers =  users {
                self.userFriendRequest = allUsers
                callback(true)
            }else{
                userFriendRequest = [UserInfo]()
                callback(false)
            }
        })
    }
    
    static func setUserSentedFriendRequest(_ callback:@escaping (Bool)->Void){
        MainModel.instance.getSentedRequestsUsersInfo(callback: {(users:[UserInfo]?) in
            if let allUsers =  users {
                self.userSentedFriendRequest = allUsers
                callback(true)
            }else{
                userSentedFriendRequest = [UserInfo]()
                callback(false)
            }
        })
    }
    
    static func setUserFriends(_ callback:@escaping (Bool)->Void){
        MainModel.instance.getUserFriendsInfo(callback: {(users:[UserInfo]?) in
            if let allUsers =  users {
                self.userFriends = allUsers
                callback(true)
            }else{
                userFriends = [UserInfo]()
                callback(false)
            }
        })
    }
}

struct GlobalFuncs {
    static func fromStringToDate (str_date : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:str_date)!
        return date
    }
    
    static func fromDateToString (date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        //        let yourDate = formatter.date(from: myString)
        //        //then again set the date format whhich type of output you need
        //        formatter.dateFormat = "dd-MMM-yyyy"
        //        // again convert your date to string
        //        let myStringafd = formatter.string(from: yourDate!)
        
        return myString
    }
}

