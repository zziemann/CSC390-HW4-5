//
//  Recent2TableViewController.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/7/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit
import CoreData

class Recent2TableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var mention: String? {didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet
    {updateUI() } }
    
    private func updateUI()
    {
        if let context = managedObjectContext where mention?.characters.count > 0 {
            let request = NSFetchRequest(entityName: "TwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ) ]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        
    }

    private func tweetCountWithMentionByTwitterUser(user: TwitterUser) -> Int?
    {
        var count: Int?
        user.managedObjectContext?.performBlockAndWait {
            let request = NSFetchRequest(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@, self.mention!", user)
            count = user.managedObjectContext?.countForFetchRequest(request, error: nil)
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentDetailsCell", forIndexPath: indexPath)

        // Configure the cell...
        if let twitterUser = fetchedResultsController?.objectAtIndexPath(indexPath) as? TwitterUser
        {
            var screenName: String?
            twitterUser.managedObjectContext?.performBlockAndWait
                {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountWithMentionByTwitterUser(twitterUser)
            {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweet" : "\(count) tweets"
            }
            else
            {
                cell.detailTextLabel?.text = ""
            }            
        }
        return cell
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
