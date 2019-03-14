//
//  Messsege.swift
//  SuperMessenger
//
//  Created by admin on 13/03/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import UIKit

class Messege  {
    
    var senderID : String
    var messege : String
    var date : String
    
    init(_senderID:String, _messege:String, _date:String) {
        senderID = _senderID
        messege = _messege
        date = _date

    }
    
    init(json:[String:Any]) {
        senderID = json["senderID"] as! String
        messege = json["messege"] as! String
        date = json["date"] as! String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        
        json["senderID"] = senderID
        json["messege"] = messege
        json["date"] = GlobalFuncs.fromDateToString(date: Date())
        
        return json
    }
}
