//
//  SqlModel.swift
//  SuperMessenger
//
//  Created by admin on 11/03/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import SQLite3

class SqlModel {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "superMessenger_database.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
        createUsersTable()
    }
    
    func createUsersTable(){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS_TABLE (USER_ID TEXT PRIMARY KEY, EMAIL TEXT, FULL_NAME TEXT, STATUS TEXT, PROFILE_IMAGE_URL TEXT, LAST_UPDATED_IMAGE INT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func dropUsersTable(){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE USERS_TABLE;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func insertToUsersTable(user:UserInfo){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO USERS_TABLE(USER_ID , EMAIL , FULL_NAME , STATUS , PROFILE_IMAGE_URL , LAST_UPDATED_IMAGE) VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = user.userUID.cString(using: .utf8)
            let fullName = user.fullName.cString(using: .utf8)
            let email = user.email.cString(using: .utf8)
            let status = user.email.cString(using: .utf8)
            let profileImageUrl = (user.profileImageUrl ?? "").cString(using: .utf8)
            let lastUpdatedImage : Int32 = (Int32(user.lastUpdatedImage ?? 0))
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, email, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 3, fullName, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 4, status, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 5, profileImageUrl, -1, nil)
            sqlite3_bind_int(sqlite3_stmt, 6, lastUpdatedImage)
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func getFromUsersTable(userID:String) -> UserInfo? {
        var sqlite3_stmt: OpaquePointer? = nil
        var user : UserInfo? = nil
        if (sqlite3_prepare_v2(database,"SELECT DATE from USERS_TABLE where USER_ID = ? ;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
        
            let id = userID.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id, -1, nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let userID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let fullName = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let email = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let status = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let profileImageUrl = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let lastUpdatedImage = Int(sqlite3_column_int(sqlite3_stmt, 5))
                
                user = UserInfo(_userUID: userID, _email: email, _fullName: fullName, _profileImageUrl: profileImageUrl)
                user!.status = status
                user!.lastUpdatedImage = lastUpdatedImage
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return user
    }
}
