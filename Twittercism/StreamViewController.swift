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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 160;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
        TwitterApi.loadTweets()
        
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchTimeline", forControlEvents: UIControlEvents.ValueChanged)
        
        reactor = TwitterApi.sharedInstance.reactor
        reactor.observe(Getter(keyPath: []), handler: { (newState) -> () in
            self.refreshControl?.endRefreshing()
        })
    }
    
    func fetchTimeline() {
        TwitterApi.loadTweets()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Bind to reactor
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath) as! TweetView
        cell.tweet = reactor.evaluate(Getter(keyPath: ["data", "tweets", indexPath.row]))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TweetDetail", sender: self)
    }
}