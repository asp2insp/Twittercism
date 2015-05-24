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
    
    var tweet : Immutable.State = Immutable.State.None {
        didSet {
            tweetContent.text = tweet.getIn(["content"]).toSwift() as? String ?? "Lorem Ipsum dolor sit amet..."
            let authorHandle = tweet.getIn(["author"]).toSwift() as? String ?? "Unknown"
            handleLabel.text = "@\(authorHandle)"
            let authorName = tweet.getIn(["name"]).toSwift() as? String ?? "Unknown"
            localizedName.text = authorName
            
            if let isRetweet = tweet.getIn(["retweet"]).toSwift() as? Bool where isRetweet {
                sourceIcon.setHeight(24)
                sourceText.setHeight(24)
                let retweetAuthor = tweet.getIn(["retweet_from"]).toSwift() as? String ?? "Unknown"
                sourceText.text = "\(retweetAuthor) retweeted"
            } else {
                sourceIcon.setHeight(0)
                sourceText.setHeight(0)
            }
            
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