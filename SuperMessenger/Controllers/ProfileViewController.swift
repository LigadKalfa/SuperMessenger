//
//  ProfileViewController.swift
//  SuperMessenger
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FullNameTextField: TextField!
    @IBOutlet weak var StatusTextField: TextField!
    
    @IBOutlet weak var SeveConstraint: NSLayoutConstraint!
    
    var userProfileData : UserInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let picGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        
        ProfileImage.addGestureRecognizer(picGesture)
        ProfileImage.isUserInteractionEnabled = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sing Out", style: .plain, target: self, action: #selector(handleSingOut))
    }
    
    @objc func handleSingOut(){
        
    }
    
    func getUserInfo(){
        IJProgressView.shared.showProgressView()
        MainModel.instance.getUserInfo(MainModel.instance.currentUser()!.uid, callback: {(user) in
        
            if(user != nil){
                self.userProfileData = user
                let imageURL = self.userProfileData!.profileImageUrl!
                MainModel.instance.getImage(imageURL, {(image) in
                    self.updateView(user: self.userProfileData!, image : image!)
                    IJProgressView.shared.hideProgressView()
                })
            }else{
                //ToDo - Alert Error
                IJProgressView.shared.hideProgressView()
            }
        })        
    }
    
    func updateView(user:UserInfo, image:UIImage){
        self.FullNameTextField.text = user.fullName
        self.StatusTextField.text = user.status
        self.ProfileImage.image = image
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
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        if let info = notification.userInfo{
            
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.ProfileImage.isHidden = true
                self.SeveConstraint.constant = rect.height + 20
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.25, animations: {
            self.ProfileImage.isHidden = false
            self.SeveConstraint.constant =  60
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func SavePressed(_ sender: Any) {
        IJProgressView.shared.showProgressView()
        
        userProfileData?.status = self.StatusTextField.text!
        userProfileData?.fullName = self.FullNameTextField.text!
        
        MainModel.instance.saveUserInfo(userProfileData!, ProfileImage.image!, {(res) in
            if(res){
                //ToDo - Alert Succsess
                IJProgressView.shared.hideProgressView()
            }else{
                //ToDo - Alert Error
                IJProgressView.shared.hideProgressView()
            }
        })

    }
}
