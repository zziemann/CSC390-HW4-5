//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/11/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TweetDB {

    @NSManaged var text: String?
    @NSManaged var unique: String?
    @NSManaged var posted: NSDate?
    @NSManaged var tweeter: TwitterUser?

}
