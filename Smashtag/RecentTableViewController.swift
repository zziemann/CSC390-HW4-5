//
//  RecentTableViewController.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/7/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit
import CoreData

class RecentTableViewController: UITableViewController {

    var searchHist = [String]() {
        didSet{ tableView.reloadData() }
        
    }
    
    var mention: String?
    var managedObjectContext: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchHist = ProjectSharing.recentSearches
        mention = ProjectSharing.mention
        managedObjectContext = ProjectSharing.managedObjectContext
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHist.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = searchHist[indexPath.row]

        return cell
    }

    
    // MARK: - Navigation

    // Prepping to go to our new recent table view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let goalvc = segue.destinationViewController as? Recent2TableViewController
        {
            goalvc.mention = mention
            goalvc.managedObjectContext = managedObjectContext
        }
    }
    

}
