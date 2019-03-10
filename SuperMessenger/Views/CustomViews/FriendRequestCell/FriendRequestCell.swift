//
//  FriendRequestCell.swift
//  SuperMessenger
//
//  Created by admin on 09/03/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit


class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    
    var currUserInfo : UserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    }
    
    @IBAction func ConfirmPressed(_ sender: Any) {
        MainModel.instance.confirmRequest(senderUser: currUserInfo!, sendTo: SystemUser.currentUser!, {(res) in
            
        })
    }
    
    @IBAction func DeclinePressed(_ sender: Any) {
        MainModel.instance.declineRequest(senderUser: currUserInfo!, sendTo: SystemUser.currentUser!, {(res) in
            
        })
    }
}

//protocol FriendRequestCellDelegate {
//    func updateTableView()
//}

//var delegate : FriendRequestCellDelegate?
//delegate?.updateTableView()
