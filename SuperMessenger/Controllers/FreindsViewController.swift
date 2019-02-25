//
//  FreindsViewController.swift
//  SuperMessenger
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import UIKit
import Firebase

class FreindsViewController: UITableViewController, UISearchBarDelegate  {

    var users = [User]()
    var usersToDisplay = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Freindes"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
        
        getFreinds()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 81
        
        tableView.register(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
        
        self.tableView.reloadData()
        setuoNavBar()
        //usersToDisplay = users.filter { $0.FullName.contains("ich")}
    }

    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
    
    func setuoNavBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Freindes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["My Friends", "Find Friends"]
        searchController.searchBar.delegate = self

    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!){
        print("123")
    }
//
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        println("searchText \(searchText)")
//    }
//
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        println("searchText \(searchBar.text)")
//    }
    
    // MARK: - Table view data source

    func getFreinds(){
        Database.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            print(snapshot)
            if (snapshot.value as? [String : AnyObject]) != nil{
                //self.createAndAppendFriend(userID: snapshot.key)
            }
        }, withCancel: nil)
    }
// TO-DO
//    func createAndAppendFriend(userID : String){
//        let user = User(userID: userID)
//
//        DispatchQueue.main.async {
//            self.users.append(user)
//            self.tableView.reloadData()
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let rowUser = users[indexPath.row]
        //cell.FullNameLabel.text = rowUser.fullName
        //cell.StatusLabel.text = rowUser.status
        //cell.ProfileImage.image = rowUser.ProfileImage
        
        return cell
    }
}
