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

protocol AddFriendCellDelegate {
    func goToChat(user : UserInfo)
}

class AddFriendCell : UITableViewCell {
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var ButtonLabel: UILabel!
    var delegate : AddFriendCellDelegate?
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
            self.delegate?.goToChat(user: currUserInfo!)
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
