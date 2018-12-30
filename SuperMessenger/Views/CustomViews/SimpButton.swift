//
//  SimpButton.swift
//  SuperMessenger
//
//  Created by admin on 09/12/2018.
//  Copyright © 2018 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit

class SimpButton: UIButton {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton(){
        backgroundColor     = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).withAlphaComponent(0.9)
        titleLabel?.font    = UIFont(name: "AvenirNextCondensed-Regular", size: 22)
        layer.cornerRadius  = frame.size.height/2
        setTitleColor(.white, for: .normal)
    }
}
 
