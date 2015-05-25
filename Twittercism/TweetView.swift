//
//  TweetCell.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

class TweetView : UITableViewCell {
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var sourceIcon: UIImageView!
    @IBOutlet weak var sourceText: UILabel!
    @IBOutlet weak var localizedName: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    let reactor = TwitterApi.sharedInstance.reactor
    let star = UIImage(named: "star.png")!
    let star_yellow = UIImage(named: "star_yellow.png")!
    let retweet = UIImage(named: "retweet.png")!
    let retweet_green = UIImage(named: "retweet_green.png")!
    
    var tweetIdString : String!
    var replyName : String!
    
    var tweet : Immutable.State = Immutable.State.None {
        didSet {
            var contentTweet : Immutable.State = tweet
            
            if let favorited = tweet.getIn(["favorited"]).toSwift() as? Bool where favorited {
                starButton.setImage(star_yellow, forState: UIControlState.Normal)
            } else {
                starButton.setImage(star, forState: UIControlState.Normal)
            }
            
            if let retweeted = tweet.getIn(["retweeted"]).toSwift() as? Bool where retweeted {
                retweetButton.setImage(retweet_green, forState: UIControlState.Normal)
            } else {
                retweetButton.setImage(retweet, forState: UIControlState.Normal)
            }
            
            if tweet.containsKey("retweeted_status") {
                retweetHeightConstraint.constant = 24
                sourceText.hidden = false
                let retweetAuthor = tweet.getIn(["user", "name"]).toSwift() as? String ?? "Unknown"
                sourceText.text = "\(retweetAuthor) retweeted"
                contentTweet = tweet.getIn(["retweeted_status"])
            } else {
                retweetHeightConstraint.constant = 0
                sourceText.hidden = true
            }
            
            tweetContent.text = contentTweet.getIn(["text"]).toSwift() as? String ?? "Lorem Ipsum dolor sit amet..."
            let authorHandle = contentTweet.getIn(["user", "screen_name"]).toSwift() as? String ?? "Unknown"
            handleLabel.text = "@\(authorHandle)"
            let authorName = contentTweet.getIn(["user", "name"]).toSwift() as? String ?? "Unknown"
            localizedName.text = authorName
            
            if let profileUrl = contentTweet.getIn(["user", "profile_image_url"]).toSwift() as? String {
                profilePic.setImageWithURL(NSURL(string: profileUrl))
                profilePic.layer.cornerRadius = 10; // this value vary as per your desire
                profilePic.clipsToBounds = true;
            }
            
            if let retweetCount = contentTweet.getIn(["retweet_count"]).toSwift() as? Int where retweetCount > 0 {
                retweetCountLabel.text = "\(retweetCount)"
            } else {
                retweetCountLabel.text = ""
            }
            
            if let favoriteCount = contentTweet.getIn(["favorite_count"]).toSwift() as? Int where favoriteCount > 0 {
                favoriteCountLabel.text = "\(favoriteCount)"
            } else {
                favoriteCountLabel.text = ""
            }
            
            timestamp.text = formatTime(contentTweet.getIn(["created_at"]).toSwift() as! String)
            
            tweetIdString = contentTweet.getIn(["id_str"]).toSwift() as! String
            replyName = contentTweet.getIn(["user", "screen_name"]).toSwift() as! String
        }
    }
    
    func formatTime(timestamp: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "EEE MMM dd HH:mm:ss +0000 yyyy"
        let date = formatter.dateFromString(timestamp)
        let seconds = abs(NSDate().timeIntervalSinceDate(date!))
        if seconds > 86400 {
            formatter.dateFormat = "MMM dd"
            return formatter.stringFromDate(date!)
        } else {
            return "\(Int(round(seconds/3600)))h"
        }
    }
    
    @IBAction func doAction(sender: UIButton) {
        switch sender {
        case starButton:
            reactor.dispatch("toggleFavoriteTweet", payload: tweetIdString)
        case retweetButton:
            reactor.dispatch("retweet", payload: tweetIdString)
        case replyButton:
            reactor.dispatch("setReply", payload: replyName)
        default:
            NSLog("Unknown Sender")
        }
    }
}