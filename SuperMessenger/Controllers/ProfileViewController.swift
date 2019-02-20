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
    //var user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let picGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        
        ProfileImage.addGestureRecognizer(picGesture)
        ProfileImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
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
}
