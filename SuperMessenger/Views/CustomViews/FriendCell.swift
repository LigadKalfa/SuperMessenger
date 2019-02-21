//
//  FriendCell.swift
//  SuperMessenger
//
//  Created by admin on 09/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ProfileImage.layer.borderWidth = 1
        ProfileImage.layer.masksToBounds = false
        ProfileImage.layer.borderColor = UIColor.black.cgColor
        ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        ProfileImage.clipsToBounds = true
    }
    
}
