//
//  Tweet.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/11/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class TweetDB: NSManagedObject
{
    // Insert code here to add functionality to your managed object subclass
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> TweetDB?
    {
        let request = NSFetchRequest(entityName: "TweetDB")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? TweetDB {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("TweetDB", inManagedObjectContext: context) as? TweetDB {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            //manages DB integrity
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo.user, inManagedObjectContext: context)
            return tweet
        }
        /*  this is a longer way of doing the above if let tweet....
        do {
            let queryResults = try context.executeFetchRequest(request)
            if let tweet = queryResults.first as? Tweet {
                return tweet
            }
        } catch let error {
            //ignore this error
        }
        */
        return nil
    }

}
