//
//  TweetCell.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

class TweetCell : UITableViewCell, TweetActionDelegate {
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var sourceIcon: UIImageView!
    @IBOutlet weak var sourceText: UILabel!
    @IBOutlet weak var localizedName: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tweetContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        actionBar.delegate = self
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
    }
    
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
            
            self.layoutIfNeeded()
            
            // TODO: Profile pic and timestamp
        }
    }
    
    func formatTime(timestamp: time_value) -> String {
        return "4h"
    }
    
    func onFavorite() {
        NSLog("Favorite")
    }
    
    func onReply() {
        NSLog("Reply")
    }
    
    func onRetweet() {
        NSLog("Retweet")
    }
}