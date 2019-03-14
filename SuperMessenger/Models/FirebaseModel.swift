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
    
    
    //MARK:- UserFunctons
    
    func getAllUsersInfo(_ callback:@escaping ([UserInfo]?) -> Void) {
        self.databaseRef!.child(consts.names.userInfoTableName).observeSingleEvent(of: .value, with: {
            (snapshot) in
            var users = [UserInfo]()
            if snapshot.exists() {
                let value = snapshot.value as! [String:[String:Any]]
                
                for val  in value{
                    let user = UserInfo(_uid: val.key , json: val.value)
                    if user.userUID != self.currentUser()?.uid {
                        users.append(user)
                    }
                }

                callback(users)
            }
            else {
                callback(nil)
            }
        })
    }
    
    
    func getRequestsUsersInfo(_ userUid : String,_ callback:@escaping ([UserInfo]?) -> Void) {
        
//        self.databaseRef!.child(consts.names.userInfoTableName).child(userUid).child(consts.names.userRequests).observeSingleEvent(of: .value
        
        self.databaseRef!.child(consts.names.userInfoTableName).child(userUid).child(consts.names.userRequests).observe(.value,  with: {
            (snapshot) in
            var users = [UserInfo]()
            if snapshot.exists() {
                let value = snapshot.value as! [String:[String:Any]]
                
                for val  in value{
                    let user = UserInfo(_uid: val.key , json: val.value)
                    users.append(user)
                }
                
                callback(users)
            }
            else {
                callback(nil)
            }
        })
        
    }
    
    func getSentedRequestsUsersInfo(_ userUid : String,_ callback:@escaping ([UserInfo]?) -> Void) {
        
//      self.databaseRef!.child(consts.names.userInfoTableName).child(userUid).child(consts.names.sentedRequests).observeSingleEvent(of: .value
        self.databaseRef!.child(consts.names.userInfoTableName).child(userUid).child(consts.names.sentedRequests).observe(.value,  with: {
            (snapshot) in
            var users = [UserInfo]()
            if snapshot.exists() {
                let value = snapshot.value as! [String:[String:Any]]
                
                for val  in value{
                    let user = UserInfo(_uid: val.key , json: val.value)
                    users.append(user)
                }
                
                callback(users)
            }
            else {
                callback(nil)
            }
        })

    }
    
    func getUserFriendsInfo(_ userUid : String,_ callback:@escaping ([UserInfo]?) -> Void) {
        
        self.databaseRef!.child(consts.names.userInfoTableName).child(userUid).child(consts.names.userFriends).observe(.value, with: {
            (snapshot) in
            var users = [UserInfo]()
            if snapshot.exists() {
                let value = snapshot.value as! [String:[String:Any]]
                
                for val  in value{
                    let user = UserInfo(_uid: val.key , json: val.value)
                    users.append(user)
                }
                
                callback(users)
            }
            else {
                callback(nil)
            }
        })
    }
    
    //MARK:- friendRequesrFunc
    
    func sendRequest(_ senderUser: UserInfo,_ sendTo : UserInfo, _ completionBlock:@escaping (Bool) -> Void) {
        let childUpdates = ["/\(senderUser.userUID)/\(consts.names.sentedRequests)/\(sendTo.userUID)": sendTo.toJson(),
                            "/\(sendTo.userUID)/\(consts.names.userRequests)/\(senderUser.userUID)": senderUser.toJson()] as [String : Any]
        
        self.databaseRef!.child(consts.names.userInfoTableName).updateChildValues(childUpdates){(error:Error?, ref:DatabaseReference) in
            if error != nil{
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func cencelRequest(_ senderUser: UserInfo,_ sendTo : UserInfo, _ completionBlock:@escaping (Bool) -> Void) {
        let childUpdates = ["/\(senderUser.userUID)/\(consts.names.sentedRequests)/\(sendTo.userUID)": nil,
                            "/\(sendTo.userUID)/\(consts.names.userRequests)/\(senderUser.userUID)": nil] as [String : Any?]
        
        self.databaseRef!.child(consts.names.userInfoTableName).updateChildValues(childUpdates){(error:Error?, ref:DatabaseReference) in
            if error != nil{
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    
    
    func declineRequest(_ senderUser: UserInfo,_ sendTo : UserInfo, _ completionBlock:@escaping (Bool) -> Void) {
        let childUpdates = ["/\(senderUser.userUID)/\(consts.names.sentedRequests)/\(sendTo.userUID)": nil,
                            "/\(sendTo.userUID)/\(consts.names.userRequests)/\(senderUser.userUID)": nil] as [String : Any?]
        
        self.databaseRef!.child(consts.names.userInfoTableName).updateChildValues(childUpdates){(error:Error?, ref:DatabaseReference) in
            if error != nil{
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func confirmRequest(_ senderUser: UserInfo,_ sendTo : UserInfo, _ completionBlock:@escaping (Bool) -> Void) {
        let childUpdates = ["/\(senderUser.userUID)/\(consts.names.sentedRequests)/\(sendTo.userUID)": nil,
                            "/\(sendTo.userUID)/\(consts.names.userRequests)/\(senderUser.userUID)": nil,
                            "/\(senderUser.userUID)/\(consts.names.userFriends)/\(sendTo.userUID)": sendTo.toJson(),
                            "/\(sendTo.userUID)/\(consts.names.userFriends)/\(senderUser.userUID)": senderUser.toJson()]
            
            as [String : Any?]
        
        self.databaseRef!.child(consts.names.userInfoTableName).updateChildValues(childUpdates){(error:Error?, ref:DatabaseReference) in
            if error != nil{
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    
    func sendMesege(_ senderUser: UserInfo,_ sendTo : UserInfo,_ messege :Messege, _ completionBlock:@escaping (Bool) -> Void) {
        let senderPath = "/\(senderUser.userUID)/\(consts.names.userFriends)/\(sendTo.userUID)/\(consts.names.chatLabel)"
        let sentToPath = "/\(sendTo.userUID)/\(consts.names.userFriends)/\(senderUser.userUID)/\(consts.names.chatLabel)"
        
        let messegeSenderKey = databaseRef!.child(consts.names.userInfoTableName).child(senderPath).childByAutoId().key
        let messegeSendToKey = databaseRef!.child(consts.names.userInfoTableName).child(sentToPath).childByAutoId().key
        
        let childUpdates = ["/\(senderPath)/\(String(describing: messegeSenderKey))": messege.toJson(), "/\(sentToPath)/\(String(describing: messegeSendToKey))": messege.toJson()] as [String : Any?]
        
        self.databaseRef!.child(consts.names.userInfoTableName).updateChildValues(childUpdates){(error:Error?, ref:DatabaseReference) in
            if error != nil{
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func getMesseges(_ systemuserID : String,_ chatWirhId : String,_ callback:@escaping ([Messege]?) -> Void) {
        
        //      self.databaseRef!.child(consts.names.userInfoTableName).child(userUid).child(consts.names.sentedRequests).observeSingleEvent(of: .value
        self.databaseRef!.child(consts.names.userInfoTableName).child(systemuserID).child(consts.names.userFriends).child(chatWirhId).child(consts.names.chatLabel).observe(.value,  with: {
            (snapshot) in
            var messeges = [Messege]()
            if snapshot.exists() {
                let value = snapshot.value as! [String:[String:Any]]
                for val  in value {
                    let msg = Messege(json: val.value)
                    messeges.append(msg)
                }

                callback(messeges)
            }
            else {
                callback(nil)
            }
        })
        
    }
}
