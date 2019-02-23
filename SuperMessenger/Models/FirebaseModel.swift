//
//  FirebaseModel.swift
//  SuperMessenger
//
//  Created by admin on 14/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class FirebaseModel {
    var databaseRef: DatabaseReference!
    lazy var storageRef = Storage.storage().reference(forURL: "gs://supermessenger-kalpich.appspot.com")
    
    init() {
        FirebaseApp.configure()
        databaseRef = Database.database().reference()
    }
    
    //MARK:- UserFunctons
    
    func addUserInfo(_ userInfo:UserInfo, _ image:UIImage?, _ completionBlock:@escaping (Bool) -> Void) {
        if image != nil {
            saveImage(folderName: consts.names.profileImagesFolderName, image: image!, userID: userInfo.userUID) { (url:String?) in
                if url != nil {
                    userInfo.profileImageUrl = url!
                }
                self.databaseRef!.child(consts.names.userInfoTableName).child(userInfo.userUID).setValue(userInfo.toJson())
                completionBlock(true)
            }
        }
        else {
            self.databaseRef!.child(consts.names.userInfoTableName).child(userInfo.userUID).setValue(userInfo.toJson())
            completionBlock(true)
        }
    }
    
    func saveImage(folderName:String, image:UIImage, userID:String, callback:@escaping (String?) -> Void) {
        let data = image.pngData()
        let imageName = "\(userID).png"
        let imageRef = storageRef.child(folderName).child(imageName)
        
        imageRef.putData(data!, metadata: nil) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func getImage(_ url:String, _ callback:@escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    func getUserInfo(_ uid:String, callback:@escaping (UserInfo?) -> Void) {
        self.databaseRef!.child(consts.names.userInfoTableName).child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                let value = snapshot.value as! [String:Any]
                let userInfo = UserInfo(_uid: uid, json: value)
                
                callback(userInfo)
            }
            else {
                callback(nil)
            }
        })
    }
    
    func signUp(_ email:String, _ password:String,_ fullName:String,_ image:UIImage? ,_ callback:@escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if authResult?.user != nil {
                
                let email = authResult!.user.email!
                
                let userInfo = UserInfo(_userUID: authResult!.user.uid, _email: email, _fullName:fullName, _profileImageUrl:nil)
                self.addUserInfo(userInfo, image, { (val) in
                    callback(true)
                })
            }
            else {
                callback(false)
            }
        }
    }
    
    func signIn(_ email:String, _ password:String, _ callback:@escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (user != nil  ) {
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    func signOut(_ callback:@escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            callback()
        } catch {
            print("Error while signing out!")
        }
    }
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
}
