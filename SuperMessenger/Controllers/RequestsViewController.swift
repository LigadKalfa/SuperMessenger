//
//  RequestsViewController.swift
//  SuperMessenger
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Kingfisher

class RequestsViewController: UITableViewController {
//UISearchBarDelegate ,UISearchControllerDelegate, FriendRequestCellDelegate
    
    let searchController = UISearchController(searchResultsController: nil)
    var allUsersInfo = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 81
        
        tableView.register(UINib(nibName: "FriendRequestCell", bundle: nil), forCellReuseIdentifier: "FriendRequestCell")
        
        SystemUser.setUserFriendRequest { (did) in
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SystemUser.userFriendRequest.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currUser = SystemUser.userFriendRequest[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
        cell.setCell(user: currUser)
        //cell.delegate = self
        
        if let userImage = SystemUser.userFriendRequest[indexPath.row].profileImage {
            cell.ProfileImage.image = userImage
            self.tableView.reloadRows(at: [indexPath] , with: UITableView.RowAnimation.none)
        }else{
            if let imageUrl = currUser.profileImageUrl {
                let cache = ImageCache.default
                
                if (cache.isCached(forKey: imageUrl)){
                    
                    cache.retrieveImage(forKey: imageUrl) { result in
                        switch result {
                        case .success(let profileCacheImage):
                            SystemUser.userFriendRequest[indexPath.row].profileImage = profileCacheImage.image
                            cell.ProfileImage.image = profileCacheImage.image
                            self.tableView.reloadRows(at: [indexPath] , with: UITableView.RowAnimation.none)

                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                else{
                    MainModel.instance.getImage(imageUrl, { (profileImage : UIImage?) in
                        SystemUser.userFriendRequest[indexPath.row].profileImage = profileImage
                        cell.ProfileImage.image = profileImage
                        self.tableView.reloadRows(at: [indexPath] , with: UITableView.RowAnimation.none)
                        
                        cache.store(profileImage!, forKey: imageUrl)
                    })
                }
            }
        }
        
        return cell
    }

    func setCurrUserInfo(){
        IJProgressView.shared.showProgressView()
        MainModel.instance.getUserInfo(MainModel.instance.currentUser()!.uid, callback: {(userInfo:UserInfo?) in
            if let user = userInfo {
                SystemUser.currentUser = user
            }
            IJProgressView.shared.hideProgressView()
        })
    }
    
    func getAllRequests(){
        MainModel.instance.getRequestUsersInfo(callback: {(users:[UserInfo]?) in
            if let allUsers =  users {
                self.allUsersInfo = allUsers
                self.tableView.reloadData()
            }
        })
    }
}


// MARK: - SearchBar

//    func setupSearchBar(){
//
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Freindes"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//
//
//    }
//
//    func searchBarSearchButtonClicked( _ searchBar: UISearchBar){
//        print(searchController.searchBar.text!)
//        print(searchController.searchBar.selectedScopeButtonIndex)
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


//
//    func updateTableView() {
//        print("cool")
//        self.tableView.reloadData()
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

