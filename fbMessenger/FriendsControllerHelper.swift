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
            
            createMessageWithText("Good morning..", friend: steve, minutesAgo: 3, context: context)
            createMessageWithText("Hello, how are you?", friend: steve, minutesAgo: 2, context: context)
            createMessageWithText("Are you interested in buying an Apple device?", friend: steve, minutesAgo: 1, context: context)
            
            let donald = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_trump_profile"
            
            createMessageWithText("You're fired", friend: donald, minutesAgo: 5, context: context)
            
            let gandhi = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            
            createMessageWithText("Love, Peace, and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)
            
            let hillary = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            createMessageWithText("Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8 * 60 * 24, context: context)

            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
        
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().dateByAddingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    print(friend.name)
                    
                    let fetchRequest = NSFetchRequest(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        
                        let fetchedMessages = try(context.executeFetchRequest(fetchRequest)) as? [Message]
                        messages?.appendContentsOf(fetchedMessages!)
                        
                    } catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedDescending})
                
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            
            let request = NSFetchRequest(entityName: "Friend")
            
            do {
                
                return try context.executeFetchRequest(request) as? [Friend]
                
            } catch let err {
                print(err)
            }
            
        }
        
        return nil
    }
    
}






