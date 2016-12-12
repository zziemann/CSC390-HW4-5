//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Zach Ziemann on 12/6/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!

    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
            // load new information from our tweet (if any)
            if let tweet = self.tweet
            {
                let hashtagColor = [NSForegroundColorAttributeName: UIColor.greenColor()]
                let URLColor = [NSForegroundColorAttributeName: UIColor.blueColor()]
                let userMentionColor = [NSForegroundColorAttributeName: UIColor.purpleColor() ]
                
                
                let tweetText = NSMutableAttributedString(string: tweet.text)
                
                for indexedHashtag in tweet.hashtags {
                    tweetText.addAttributes(hashtagColor, range: indexedHashtag.nsrange)
                }
                for indexedURL in tweet.urls {
                    tweetText.addAttributes(URLColor , range: indexedURL.nsrange)
                }
                for indexedUserMention in tweet.userMentions {
                    tweetText.addAttributes(userMentionColor , range: indexedUserMention.nsrange)
                }
                
                tweetTextLabel?.text = tweet.text
                if tweetTextLabel?.text != nil  {
                    for _ in tweet.media {
                        tweetTextLabel.text! += " 📷"
                    }
                }
                
                tweetTextLabel?.attributedText = tweetText
                
                tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
                
                if let profileImageURL = tweet.user.profileImageURL {
                    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                    dispatch_async(dispatch_get_global_queue(qos, 0)) {
                        if let imageData = NSData(contentsOfURL: profileImageURL) {
                            dispatch_async(dispatch_get_main_queue()) {
                                if profileImageURL == self.tweet?.user.profileImageURL {
                                    self.tweetProfileImageView?.image = UIImage(data: imageData)
                                }
                            }
                        }
                    }
                }
                
                let formatter = NSDateFormatter()
                if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                } else {
                    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                }
                tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
                
            
            
        }
    }
}
