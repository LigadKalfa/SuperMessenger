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
    
    var user = Auth.auth().currentUser
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let picGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        user = Auth.auth().currentUser
        ProfileImage.addGestureRecognizer(picGesture)
        ProfileImage.isUserInteractionEnabled = true
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
    
}
