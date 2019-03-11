
//
//  AllChatsAssociator.swift
//  SuperMessenger
//
//  Created by admin on 05/01/2019.
//  Copyright © 2019 LigadKalfa&DanielPichhadze. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension AllChatsController{
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let boy = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            boy.name = "Boyfriend Of Bijo"
            boy.profileImageName = "boy.jpeg"

            createMessageWithText(text: "Bijo is my sweet little lover", friend: boy, minutesAgo: 2, context: context)
            
            createGirlMessagesWithContext(context: context)
            
            let bijo = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            bijo.name = "Bijo Himself"
            bijo.profileImageName = "bijo.jpeg"
            
            createMessageWithText(text: "Give me Hachapuri!", friend: bijo, minutesAgo: 10, context: context)
            
            let mama = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mama.name = "Mamaliga"
            mama.profileImageName = "Mama.jpeg"

            createMessageWithText(text: "Oh sweet son!", friend: mama, minutesAgo: 60 * 24, context: context)

            let pops = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            pops.name = "Don Pepe"
            pops.profileImageName = "Pops.jpeg"
            
            createMessageWithText(text: "Oh sweet son!", friend: pops, minutesAgo: 8 * 60 * 24, context: context)

            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    private func createGirlMessagesWithContext(context: NSManagedObjectContext){
        let girl = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        girl.name = "Bijo's Girlfriend"
        girl.profileImageName = "someProfile.jpeg"
        
        createMessageWithText(text: "Hello, my name is Bijo's girl, wanna dance tonight?? <3 i have a" +
            "lot to tell you about how my day was going and how every body love me at work!", friend: girl, minutesAgo: 3, context: context)
        createMessageWithText(text: "and tonight? -_-", friend: girl, minutesAgo: 2, context: context)
        createMessageWithText(text: "seriosly i will always love bijo bijoshvily", friend: girl, minutesAgo: 0, context: context)
        createMessageWithText(text: "Do you love me do you do you?", friend: girl, minutesAgo: 0, context: context)

        //response message
        createMessageWithText(text: "Well, dear, im in love with you.", friend: girl, minutesAgo: 0, context: context, isSender: true)
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double,context: NSManagedObjectContext,
                                       isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60) as Date
        message.isSender = isSender
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            messages = [Message]()
            
            if let friends = fetchFriends() {
                for friend in friends {
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                        fetchRequest.fetchLimit = 1
                
                    do {
                        let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                        
                    } catch let err {
                        print (err)
                    }
                }
                
                messages?.sort(by: {$0.date!.compare($1.date!) == .orderedDescending})
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                
                return try context.fetch(request) as? [Friend]
                
            } catch let err {
                print(err)
            }
        }
        
        return nil
    }
    
    func clearData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }

                try(context.save())
                
            } catch let err {
                print (err)
            }
        }
    }
}
