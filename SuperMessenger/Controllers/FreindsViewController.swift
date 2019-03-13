//
//  FreindsViewController.swift
//  SuperMessenger
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Kingfisher

//UISearchBarDelegate ,UISearchControllerDelegate, AddFriendCellDelegate
class FreindsViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var allUsersInfo = [UserInfo]()
    
    var didRequestsGeted : Bool = false
    var didFriendsGeted : Bool = false
    var didSentedRequestsGeted : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 81
        
        tableView.register(UINib(nibName: "AddFriendCell", bundle: nil), forCellReuseIdentifier: "AddFriendCell")
        getAllUsersInfo()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersInfo.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currUser = allUsersInfo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell", for: indexPath) as! AddFriendCell
        cell.setCell(user: currUser)
        //cell.delegate = self
        
        //Chek if Image Exist
        if let userImage = self.allUsersInfo[indexPath.row].profileImage {
            cell.ProfileImage.image = userImage
            self.tableView.reloadRows(at: [indexPath] , with: UITableView.RowAnimation.none)
        }else{
            if let imageUrl = currUser.profileImageUrl {
                let cache = ImageCache.default
                
                if (cache.isCached(forKey: imageUrl)){
                    
                    cache.retrieveImage(forKey: imageUrl) { result in
                        switch result {
                        case .success(let profileCacheImage):
                            self.allUsersInfo[indexPath.row].profileImage = profileCacheImage.image
                            cell.ProfileImage.image =  profileCacheImage.image
                            self.tableView.reloadRows(at: [indexPath] , with: UITableView.RowAnimation.none)

                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                else
                {
                    MainModel.instance.getImage(imageUrl, { (profileImage : UIImage?) in
                        self.allUsersInfo[indexPath.row].profileImage = profileImage
                        cell.ProfileImage.image = profileImage
                        self.tableView.reloadRows(at: [indexPath] , with: UITableView.RowAnimation.none)
                        
                        cache.store(profileImage!, forKey: imageUrl)
                    })
                }
            }
        }
        return cell
    }
    
    
    func getAllUsersInfo(){
        MainModel.instance.getAllUsersInfo(callback: {(users:[UserInfo]?) in
            if let allUsers =  users {
                self.allUsersInfo = allUsers
                
                // dont show users requested 
                SystemUser.setUserFriendRequest { (res) in
                    if res {
                        for user in SystemUser.userFriendRequest{
                            self.allUsersInfo = self.allUsersInfo.filter{ $0.userUID != user.userUID}
                        }
                    }
                    self.didRequestsGeted = true
                    self.updateTabel()
                }
                SystemUser.setUserSentedFriendRequest { (res) in
                    self.didSentedRequestsGeted = true
                    self.updateTabel()
                }
                SystemUser.setUserFriends { (res) in
                    self.didFriendsGeted = true
                    self.updateTabel()
                }
            }
        })
    }
    
    func updateTabel(){
        if(didRequestsGeted && didFriendsGeted && didSentedRequestsGeted){
            self.tableView.reloadData()
        }
    }
}


//    func setupSearchBar(){
//
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Freindes"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//        searchController.searchBar.scopeButtonTitles = ["Add Friends", "Friend req"]
//        searchController.searchBar.delegate = self
//
//    }
//
//    func searchBarSearchButtonClicked( _ searchBar: UISearchBar){
//        print(searchController.searchBar.text!)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        print(searchController.searchBar.selectedScopeButtonIndex)
//        //print(searchController.searchBar.scopeButtonTitles![selectedScope])
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Show all")
//    }

//    func updateTableView(user : UserInfo) {
//        let index = allUsersInfo.firstIndex(where: {$0.userUID == user.userUID})
//        self.tableView.reloadData()
//    }
