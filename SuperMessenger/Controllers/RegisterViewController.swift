//
//  RegisterViewController.swift
//  SuperMessenger
//
//  Created by admin on 03/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ProfileImage: UIImageView!
    let backgroundImageView = UIImageView()
    @IBOutlet weak var FullNmaeTextField: TextField!
    @IBOutlet weak var EmailTextField: TextField!
    @IBOutlet weak var PasswordTextField: TextField!
    @IBOutlet weak var RenterPasswordTextField: TextField!
    @IBOutlet weak var RegisrerButtonConstrain: NSLayoutConstraint!
    
    //var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround()
        
        //ref = Database.database().reference()
        let picGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        
        ProfileImage.addGestureRecognizer(picGesture)
        ProfileImage.isUserInteractionEnabled = true
        
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
                self.ProfileImage.isHidden = true
                self.RegisrerButtonConstrain.constant = rect.height + 10
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.25, animations: {
            self.ProfileImage.isHidden = false
            self.RegisrerButtonConstrain.constant =  20
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
    
    @IBAction func RegisterPressed(_ sender: Any) {
        //validaton
        IJProgressView.shared.showProgressView()
        if (!isValidUserName(Input: FullNmaeTextField.text)){
            alertError(error: "Enter your full name")
        }else if(!isValidEmail(testStr: EmailTextField.text)){
            alertError(error: "Email not valid")
        }else if (!isPasswordValid(password: PasswordTextField.text)){
            alertError(error: "Password must have 8 cahars")
        }else if (PasswordTextField.text != RenterPasswordTextField.text){
            alertError(error: "Passwords not maching")
        }else{
            let email = EmailTextField.text!
            let password = PasswordTextField.text!
            let fullName = FullNmaeTextField.text!
            let image : UIImage? = ProfileImage.image
            
            MainModel.instance.signUp(email, password, fullName, image, {(res) in
                if(res){
                    SystemUser.setCurrUserInfo({ (did) in
                        if did {
                            self.performSegue(withIdentifier: "FromRegisterToTabBar", sender: self)
                            IJProgressView.shared.hideProgressView()
                        }else{
                            self.alertError(error: "Error occured")
                            IJProgressView.shared.hideProgressView()
                        }
                    })
                    
                }else{
                    self.alertError(error: "Error occured")
                    IJProgressView.shared.hideProgressView()
                }
            })
        }
    }
   
    
    func alertError(error : String){
        let alert = UIAlertController(title: error, message: nil , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        IJProgressView.shared.hideProgressView()
        self.present(alert, animated: true)
    }
    
    func isValidEmail(testStr:String?) -> Bool {
        if testStr == nil{ return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidUserName(Input:String?) -> Bool {
        if Input == nil{ return false }
        let RegEx = "^[a-zA-Z0-9_ ]*${5,30}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    func isPasswordValid(password : String?) -> Bool{
        if password == nil{ return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var SelectedImageFromPicker : UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            SelectedImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            SelectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage : UIImage = SelectedImageFromPicker {
            ProfileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BackToLoginPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
