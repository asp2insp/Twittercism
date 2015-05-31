//
//  MentionsViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/31/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

let MENTIONS = Getter(keyPath: ["mentions"])

class MentionsViewController : UITableViewController {
    var reactor : Reactor!
    var keys : [UInt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchMentions", forControlEvents: UIControlEvents.ValueChanged)
        
        reactor = TwitterApi.sharedInstance.reactor
        TwitterApi.loadMentions()
        self.title = "Mentions"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keys.append(reactor.observe(TWEETS, handler: { (newState) -> () in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        reactor.unobserve(keys)
    }
    
    func fetchMentions() {
        TwitterApi.loadMentions()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.evaluate(MENTIONS).count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath) as! TweetView
        cell.tweet = reactor.evaluate(MENTIONS.extendKeyPath([indexPath.row]))
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
}