//
//  AddFriendCell.swift
//  SuperMessenger
//
//  Created by admin on 27/02/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class AddFriendCell : UITableViewCell {
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var ButtonLabel: UILabel!
    
    var currUserInfo : UserInfo?
    var relishenship : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(user : UserInfo) {
        ProfileImage.layer.borderWidth = 1
        ProfileImage.layer.masksToBounds = false
        ProfileImage.layer.borderColor = UIColor.black.cgColor
        ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        ProfileImage.clipsToBounds = true
        currUserInfo = user
        FullNameLabel.text = user.fullName
        StatusLabel.text = user.status
        //AddButton.imageView?.image = getButtonImage(user)
        setButtonImage(user)
        self.updateConstraints()
    }
    
    func setButtonImage(_ userToCheck:UserInfo) {
        
        if(SystemUser.userSentedFriendRequest.firstIndex(where: {$0.userUID == userToCheck.userUID}) != nil){
            ButtonLabel.text = consts.names.cencelRequestLabel
            AddButton.setImage(UIImage(named: "FriendRequestChecked"), for: .normal)
            //AddButton.imageView!.image = UIImage(named: "FriendRequestChecked")!
            
        }else if(SystemUser.userFriends.firstIndex(where: {$0.userUID == userToCheck.userUID}) != nil){
            ButtonLabel.text = consts.names.chatLabel
            AddButton.setImage(UIImage(named: "Chat"), for: .normal)
            //AddButton.imageView!.image = UIImage(named: "Chat")!
            
        }else{
            ButtonLabel.text = consts.names.AddFriendLabel
            AddButton.setImage(UIImage(named: "FriendRequest"), for: .normal)
            //AddButton.imageView!.image = UIImage(named: "FriendRequest")!
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        if(ButtonLabel.text == consts.names.cencelRequestLabel){
            cencelSendedRequest()
        }else if (ButtonLabel.text == consts.names.chatLabel){
            //Go To Chat
            var isStoredUser = false
            let user = currUserInfo
            let currUser = SystemUser.currentUser
            
            var allFriendsInCoreData = AllChatsController.fetchFriends()
            let layout = UICollectionViewFlowLayout()
            let controller = ChatLogController(collectionViewLayout: layout)
            
            for friend in allFriendsInCoreData!{
                if(friend.userUID == user?.userUID){
                    isStoredUser = true
                    controller.friend = friend
                }                                
            }
            //let ViewController2 = ViewController2(nibName: "ViewController2", bundle: nil)
            //self.navigationController.pushViewController(ViewController2, animated: true)
            
            if (isStoredUser){
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    
                    // topController should now be your topmost view controller
                }

                //navigationController?.pushViewController(controller, animated: true)
            }
            
            if (!isStoredUser)
            {
                let delegate = UIApplication.shared.delegate as? AppDelegate
                
                if let context = delegate?.persistentContainer.viewContext {
                    
                    let newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
                    newFriend.name = user?.fullName
                    newFriend.profileImageName = user?.profileImageUrl
                    
                    AllChatsController.createMessageWithText(text: "dfd", friend: newFriend, minutesAgo: 0, context: context, isSender: false)

                    do {
                        try(context.save())
                    } catch let err {
                        print(err)
                    }
                }

               // controller.friend = friend
            }
            
        }else{            
            sendRequest()
        }
    }
    
    func sendRequest(){
        IJProgressView.shared.showProgressView()
        MainModel.instance.sendRequest(senderUser: SystemUser.currentUser!, sendTo: currUserInfo!, {(ifSet:Bool) in
            if(ifSet){
                self.AddButton.imageView?.image = UIImage(named: "FriendRequestChecked")!
                self.updateConstraints()
            }
            IJProgressView.shared.hideProgressView()
        })
    }
    
    func cencelSendedRequest(){
        IJProgressView.shared.showProgressView()
        MainModel.instance.cencelRequest(senderUser: SystemUser.currentUser!, sendTo: currUserInfo!, {(ifSet:Bool) in
            if(ifSet){
                self.AddButton.imageView?.image = UIImage(named: "FriendRequest")!
                self.updateConstraints()
            }
            IJProgressView.shared.hideProgressView()
        })
    }
    
    func presentChatControler(){
        
    }
}

//protocol AddFriendCellDelegate {
//    func updateTableView(user : UserInfo)
//}

//var delegate : AddFriendCellDelegate?
//self.delegate?.updateTableView(user: self.currUserInfo!)
