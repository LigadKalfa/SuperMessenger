//
//  SimpTextField.swift
//  SuperMessenger
//
//  Created by admin on 09/12/2018.
//  Copyright © 2018 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupField()
    }
    
    private func setupField(){
        tintColor               = .white
        textColor               = UIColor.darkGray
        font                    = UIFont(name: "AvenirNextCondensed-DemiBold", size: 18)
        backgroundColor         = UIColor(white: 1.0, alpha: 0.5)
        autocorrectionType      = .no
        layer.cornerRadius      = 25.0
        clipsToBounds           = true
        
        let placeholder         = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont     = UIFont(name: "AvenirNextCondensed-DemiBold", size: 18)
        attributedPlaceholder   = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: placeholderFont])
        
        let indentView          = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView                = indentView
        leftViewMode            = .always
    }
}
