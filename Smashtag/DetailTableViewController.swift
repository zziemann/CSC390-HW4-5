//
//  DetailTableViewController.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/7/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit
import Twitter

class DetailTableViewController: UITableViewController {

    var tweet: Twitter.Tweet?

    func updateTweets(newTweet: Twitter.Tweet )
    {
        tweet = newTweet
    }        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Attempts to try to get that back buttoning showing up
        //self.navigationItem.leftItemsSupplementBackButton = true
        //self.navigationItem.leftBarButtonItem?.enabled = true
        //self.navigationItem.hidesBackButton = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows
        switch (section)
        {
        case 0:
            return (tweet?.media.count)!
        case 1:
            return (tweet?.hashtags.count)!
        case 2:
            return (tweet?.userMentions.count)!
        case 3:
            return (tweet?.urls.count)!
        default:
            return 0
        }
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "DetailCell"
        static let ImageCellIdentifier = "ImageCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)
        
        
        switch (indexPath.section)
        {
        case 0:
            let imageCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            imageCell.imageView?.image = UIImage(  data: NSData(contentsOfURL: (tweet?.media[0].url)!  )!    )
        case 1:
            cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
            break
        case 2:
            cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
            break
        case 3:
            cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
            break
        default:
            cell.textLabel?.text = "Error loading cell contents"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            let tweetImage = UIImage(  data: NSData(contentsOfURL: (tweet?.media[0].url)!  )!    )
            if view.bounds.width > tweetImage?.size.width
            {
                return CGFloat((tweetImage?.size.height)!)
            }
            else
            {
                return CGFloat((tweetImage?.size.height)! / ( (tweetImage?.size.width)!*1.1 / view.bounds.width )  )
            }
        }
        return UITableViewAutomaticDimension
    }
        
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let indexPath = tableView.indexPathForSelectedRow {
            print("This section is:" + String(indexPath.section))
            if indexPath.section == 3 {
                if let url = NSURL(string: String(tweet?.urls[indexPath.row]) ) {
                    UIApplication.sharedApplication().openURL(url)
                }
                return false
            }
        }
        return true
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section)
        {
        case 0:
            if ((tweet?.media.count)! != 0 ) {
                return "Images"
            }
            else {
                return ""
            }
            
        case 1:
            if ((tweet?.hashtags.count)! != 0 ) {
                return "Hashtags"
            }
            else {
                return ""
            }
        case 2:
            if ((tweet?.userMentions.count)! != 0 ) {
                return "User Mentions"
            }
            else {
                return ""
            }
        case 3:
            if ((tweet?.urls.count)! != 0 ) {
                return "URLs"
            }
            else {
                return ""
            }
        default:
            return "Something didn't work with header"
        }
    }
}
