//
//  ViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

let TWEETS = Getter(keyPath: ["stream"])

class StreamViewController : UITableViewController {
    var reactor : Reactor!
    var keys : [UInt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchTimeline", forControlEvents: UIControlEvents.ValueChanged)
        
        reactor = TwitterApi.sharedInstance.reactor
        TwitterApi.loadTweets()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keys.append(reactor.observe(TWEETS, handler: { (newState) -> () in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }))
        keys.append(reactor.observe(WriteTweetViewController.REPLY, handler: { (newState) -> () in
            self.performSegueWithIdentifier("reply", sender: self)
        }))
        keys.append(reactor.observe(TARGET_TIMELINE, handler: { (newState) -> () in
            println(self.reactor.evaluateToSwift(CURRENT_TAB) as? String)
            if let tab = self.reactor.evaluateToSwift(CURRENT_TAB) as? String where tab == "drawer_Timeline" {
                self.performSegueWithIdentifier("profile", sender: self)
            }
        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        reactor.unobserve(keys)
    }
    
    func fetchTimeline() {
        TwitterApi.loadTweets()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.evaluate(TWEETS).count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath) as! TweetView
        cell.tweet = reactor.evaluate(TWEETS.extendKeyPath([indexPath.row]))
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reactor.dispatch("setDetail", payload: [
            "index": indexPath.row,
            "source": "home"
        ])
        self.performSegueWithIdentifier("TweetDetail", sender: self)
    }
}