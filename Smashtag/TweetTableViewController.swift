//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/6/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

    //this creates the new tweets and updates the table and data
    var tweets = [Array<Tweet>]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    //this is what we are searching for, and when we have a new one it will remove all our current tweets if any
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
            ProjectSharing.recentSearches.append(title!)
            ProjectSharing.mention = searchText
            ProjectSharing.managedObjectContext = managedObjectContext
        }
    }
    
    private var twitterRequest: Twitter.Request? {
        if let query = searchText where !query.isEmpty {
            return Twitter.Request(search: query + " -filter: retweets", count: 100)
        }
        return nil
    }
    
    
    private var lastTwitterRequest: Twitter.Request?
    
    //this actually searches for tweets then calls the tweets var
    private func searchForTweets()
    {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            //if its empty, just ignore it
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                            weakSelf?.updateDatabase(newTweets)
                        }
                    }
                }}
        }
    }
    
    private func updateDatabase(newTweets: [Twitter.Tweet] ) {
        //managed Object stuff always requires the Block
        managedObjectContext?.performBlock {
            for twitterInfo in newTweets {
                //create a new, unique Tweet with that Twitter info
                _ = TweetDB.tweetWithTwitterInfo(twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension       
        
        //self.navigationItem.hidesBackButton = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    // MARK: - UITableview data source (these actually load up the table)

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count  //its a little more complicated than this....
    }
        
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    @IBOutlet weak var searchTextField: UITextField!
        {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }

    
    
    //sending over the selected tweet information
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var destinationvc = segue.destinationViewController
        
        if let navcon  = destinationvc as? UINavigationController
        {
            destinationvc = navcon.visibleViewController!
        }
        
        if let clickedTweet = sender as? TweetTableViewCell
        {
            if let destination = destinationvc as? DetailTableViewController
            {
                destination.updateTweets(clickedTweet.tweet!)
            }
        }
        
    }    
}


    


