//
//  ChatViewController.swift
//  SuperMessenger
//
//  Created by admin on 13/03/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendViewConstrain: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    var user : UserInfo?
    var mesegess = [Messege]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getMesseges()
        setUpTopBar()
        setupController()        
    }
    
    func setUpTopBar()  {
        ProfileImage.layer.borderWidth = 1
        ProfileImage.layer.masksToBounds = false
        ProfileImage.layer.borderColor = UIColor.black.cgColor
        ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        ProfileImage.clipsToBounds = true
        ProfileImage.image = user?.profileImage
        fullNameLabel.text = user?.fullName
    }
    
    
    func setupController(){
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessegeCell", bundle: nil), forCellReuseIdentifier: "MessegeCell")
        messageTableView.rowHeight = UITableView.automaticDimension
        
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
                self.sendViewConstrain.constant = rect.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.25, animations: {
            self.sendViewConstrain.constant =  0
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: - TableView DataSource Methods
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeCell", for: indexPath) as! MessegeCell
        
        cell.setupCell(_messege: mesegess[indexPath.row])
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mesegess.count
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if let msgTxt = textField.text{
            IJProgressView.shared.showProgressView()
            textField.endEditing(true)
            textField.isEnabled = false
            sendButton.isEnabled = false
            
            let msg  = Messege(_senderID: SystemUser.currentUser!.userUID, _messege: msgTxt, _date: GlobalFuncs.fromDateToString(date: Date()))
            MainModel.instance.sendMessege(senderUser: SystemUser.currentUser!, sendTo: user!, messege: msg,  {(res) in
                if(!res){
                    self.alertError(error: "Somting Wrong")
                }
                self.textField.text = ""
                IJProgressView.shared.hideProgressView()
                self.textField.isEnabled = true
                self.sendButton.isEnabled = true
            })
        }
    }
    
    
    func getMesseges() {
        MainModel.instance.getMesseges(chatWith: user!, callback: {(newMsg) in
            if let msg = newMsg {
                self.mesegess = msg.sorted(by: { $0.date < $1.date })
                self.messageTableView.reloadData()
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
