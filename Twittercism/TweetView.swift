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
    
    var tweet : Immutable.State = Immutable.State.None {
        didSet {
            var contentTweet : Immutable.State = tweet
            
            if let retweetCount = tweet.getIn(["retweet_count"]).toSwift() as? Int where retweetCount > 0 {
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
            
            // TODO: Profile pic and timestamp
        }
    }
    
    func formatTime(timestamp: time_value) -> String {
        return "4h"
    }
    
    @IBAction func doAction(sender: UIButton) {
        switch sender {
        case starButton:
            NSLog("Favorite")
        case retweetButton:
            NSLog("Retweet")
        case replyButton:
            NSLog("Reply")
        default:
            NSLog("Unknown Sender")
        }
    }
}