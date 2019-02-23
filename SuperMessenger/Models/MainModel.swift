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
    //var sqlModel = SqlModel();
    
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
    
//    func getUserInfo(_ uid:String, callback:@escaping (UserInfo?) -> Void) -> UserInfo? {
//        var currUser:UserInfo? = nil
//
//        firebaseModel.getUserInfo(uid) { (info:UserInfo?) in
//            if(info != nil) {
//                currUser = info
//            }
//        }
//        return currUser
//        //getUserInfoFromLocalAndNotify(uid, callback)
//    }

    
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
        if let data = image.jpegData(compressionQuality: 0.8) {
            //let filename = getDocumentsDirectory().appendingPathComponent(name)
            //try? data.write(to: filename)
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
}
