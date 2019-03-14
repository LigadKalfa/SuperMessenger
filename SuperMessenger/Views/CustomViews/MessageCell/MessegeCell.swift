//
//  MessegeCell.swift
//  SuperMessenger
//
//  Created by admin on 13/03/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit

class MessegeCell: UITableViewCell {
    
    
    @IBOutlet weak var messegeLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    
    @IBOutlet weak var conteinerView: UIView!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var messege : Messege?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell(_messege: messege)
    }
    
    func setupCell(_messege:Messege?) {
        messege = _messege
        messegeLabel.text = messege?.messege
        //DateLabel.text = GlobalFuncs.fromDateToString(date: messege!.date)
        conteinerView.layer.cornerRadius = conteinerView.frame.height/2
        DateLabel.text = messege?.date
        
        if messege?.senderID == SystemUser.currentUser?.userUID {
            rightConstraint.constant = 40
            leftConstraint.constant = 10
            conteinerView.backgroundColor = UIColor.lightGray
        }else{
            leftConstraint.constant = 40
            rightConstraint.constant = 10
            conteinerView.backgroundColor = UIColor.green
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

