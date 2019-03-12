//
//  MainModel.swift
//  SuperMessenger
//
//  Created by admin on 14/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainModel {
    static let instance:MainModel = MainModel()
    
    var firebaseModel = FirebaseModel();
    var sqlModel = SqlModel();
    
    var User:UserInfo? = nil
    
    private init(){
    }
    
    func signIn(_ email:String, _ password:String, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signIn(email, password, callback)
    }
    
    func signUp(_ email:String, _ password:String, _ fullName:String,_ image:UIImage?, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signUp(email, password, fullName, image, callback)
    }
    
    func signOut(_ callback:@escaping () -> Void) {
        firebaseModel.signOut(callback)
    }
    
    
    func getUserInfo(_ uid:String, callback:@escaping (UserInfo?) -> Void) {
        firebaseModel.getUserInfo(uid) { (info:UserInfo?) in
                callback(info)
        }
    }
    
    func saveUserInfo(_ userInfo:UserInfo, _ image:UIImage?, _ completionBlock:@escaping (Bool) -> Void){
        firebaseModel.addUserInfo(userInfo, image, completionBlock)
    }
    
    func getImage(_ url:String, _ callback:@escaping (UIImage?)->Void){
        firebaseModel.getImage(url){(image:UIImage?) in
            callback(image)
        }
    }
    
    func saveImageToFile(image:UIImage, name:String){
        if let data = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    func currentUser() -> User? {
        return firebaseModel.currentUser()
    }
    
    func getAllUsersInfo(callback:@escaping ([UserInfo]?) -> Void){
        firebaseModel.getAllUsersInfo({(users:[UserInfo]?) in
            callback(users)
        })
    }
    
    func getRequestUsersInfo(callback:@escaping ([UserInfo]?) -> Void){
        firebaseModel.getRequestsUsersInfo(SystemUser.currentUser!.userUID,{(users:[UserInfo]?) in
            callback(users)
        })
    }
    
    func getSentedRequestsUsersInfo(callback:@escaping ([UserInfo]?) -> Void){
        firebaseModel.getSentedRequestsUsersInfo(SystemUser.currentUser!.userUID,{(users:[UserInfo]?) in
            callback(users)
        })
    }
    
    func getUserFriendsInfo(callback:@escaping ([UserInfo]?) -> Void){
        firebaseModel.getUserFriendsInfo(SystemUser.currentUser!.userUID,{(users:[UserInfo]?) in
            if let friends = users {
                for friend in friends {
                    self.sqlModel.insertToUsersTable(user: friend)
                }
            }
            callback(users)
        })
    }
    
    func sendRequest(senderUser:UserInfo, sendTo:UserInfo,  _ completionBlock:@escaping (Bool) -> Void) {
        firebaseModel.sendRequest(senderUser, sendTo, {(ifSet:Bool) in
            completionBlock(ifSet)
        })
        
    }
    
    func cencelRequest(senderUser:UserInfo, sendTo:UserInfo,  _ completionBlock:@escaping (Bool) -> Void) {
        firebaseModel.cencelRequest(senderUser, sendTo, {(ifSet:Bool) in
            completionBlock(ifSet)
        })
    }
    
    func declineRequest(senderUser:UserInfo, sendTo:UserInfo,  _ completionBlock:@escaping (Bool) -> Void)  {
        firebaseModel.declineRequest(senderUser, sendTo, {(ifSet:Bool) in
            completionBlock(ifSet)
        })
    }
    func confirmRequest(senderUser:UserInfo, sendTo:UserInfo,  _ completionBlock:@escaping (Bool) -> Void){
        firebaseModel.confirmRequest(senderUser, sendTo, {(ifSet:Bool) in
            completionBlock(ifSet)
        })
    }
    
}
