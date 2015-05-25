//
//  ViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class StreamViewController : UITableViewController {
    var reactor : Reactor!
    var keys : [UInt] = []
    let TWEETS = Getter(keyPath: ["stream"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 160;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
        TwitterApi.loadTweets()
        
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchTimeline", forControlEvents: UIControlEvents.ValueChanged)
        
        reactor = TwitterApi.sharedInstance.reactor
        keys.append(reactor.observe(TWEETS, handler: { (newState) -> () in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }))
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
        cell.tweet = reactor.evaluate(Getter(keyPath: ["stream", indexPath.row]))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TweetDetail", sender: self)
    }
}