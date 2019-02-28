//
//  LoginViewController.swift
//  SuperMessenger
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var EmailTextField: TextField!
    @IBOutlet weak var PasswordTextField: TextField!
    @IBOutlet weak var JoinConstraint: NSLayoutConstraint!
    
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround()
        
        //userID = UserDefaults.standard.string(forKey: "currUserID") ?? ""
        //print(Auth.auth().currentUser!.uid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        if let info = notification.userInfo{
            
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.IconImage.isHidden = true
                self.JoinConstraint.constant = rect.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.25, animations: {
            self.IconImage.isHidden = false
            self.JoinConstraint.constant =  60
            self.view.layoutIfNeeded()
        })
    }
    
    func setBackGround(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "background-Rock.jpeg")
        
        view.sendSubviewToBack(backgroundImageView)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        
        let email = self.EmailTextField.text!
        let password = self.PasswordTextField.text!
        
        IJProgressView.shared.showProgressView()
        
        MainModel.instance.signIn(email, password, { (res) in
            if(res){
                self.performSegue(withIdentifier: "FromLoginToTabBar", sender: self)
                IJProgressView.shared.hideProgressView()
            }else{
                self.alertError(error: "email or password is wrong")
                UIApplication.shared.endIgnoringInteractionEvents()
                IJProgressView.shared.hideProgressView()
            }
        })
    }
    
    func alertError(error : String){
        let alert = UIAlertController(title: error, message: nil , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        IJProgressView.shared.hideProgressView()
        self.present(alert, animated: true)
    }
}



