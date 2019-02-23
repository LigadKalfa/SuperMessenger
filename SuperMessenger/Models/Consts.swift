//
//  Consts.swift
//  SuperMessenger
//
//  Created by admin on 14/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import UIKit

struct consts{
    struct names {
        static let userInfoTableName: String = "users"
        static let profileImagesFolderName: String = "ProfileImages"
    }
    
    struct text {
        static let lineBreak:String = "\n"
    }
    
//    struct general {
//        static func convertTimestampToStringDate(_ serverTimestamp: Double, _ format:String = "dd/MM/yyyy HH:mm") -> String {
//            let x = serverTimestamp / 1000
//            let date = NSDate(timeIntervalSince1970: x)
//            let formatter = DateFormatter()
//            formatter.dateFormat = format
//
//            return formatter.string(from: date as Date)
//        }
//
//        static func getCancelAlertController(title:String, messgae:String, buttonText:String = "Dismiss") -> UIAlertController
//        {
//            let alertController = UIAlertController(title: title, message: messgae, preferredStyle: UIAlertController.Style.alert)
//            alertController.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.cancel, handler: nil))
//
//            return alertController
//        }
//    }
}
