//
//  ProjectSharing.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/7/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import Foundation
import CoreData

class ProjectSharing {
    static let sharedInstance = ProjectSharing()
    private init() {}
    
    static var recentSearches: [String] = []
    static var mention: String?
    static var managedObjectContext: NSManagedObjectContext?
    
}
