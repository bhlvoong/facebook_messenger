//
//  FriendsControllerHelper.swift
//  fbMessenger
//
//  Created by Brian Voong on 4/4/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

import CoreData

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    
                    let objects = try(context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.deleteObject(object)
                    }
                }
                
                try(context.save())
                
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            let mark = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            
            let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            message.friend = mark
            message.text = "Hello, my name is Mark. Nice to meet you..."
            message.date = NSDate()
            
            let steve = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            steve.name = "Steve Jobs"
            steve.profileImageName = "steve_profile"
            
            let messageSteve = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            messageSteve.friend = steve
            messageSteve.text = "Apple creates great iOS Devices for the world..."
            messageSteve.date = NSDate()
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
        
    }
    
    func loadData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "Message")
            
            do {
            
                messages = try(context.executeFetchRequest(fetchRequest)) as? [Message]
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
}






