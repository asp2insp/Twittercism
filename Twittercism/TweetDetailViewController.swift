//
//  TweetDetailViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/23/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

class TweetDetailViewController : UIViewController, UITableViewDataSource {
    var reactor : Reactor!
    var keys : [UInt] = []
    @IBOutlet var tableView: UITableView!
    let DETAIL_SOURCE = Getter(keyPath: ["ui", "detail", "source"])
    let DETAIL_INDEX = Getter(keyPath: ["ui", "detail", "index"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 160;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
        reactor = TwitterApi.sharedInstance.reactor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keys.append(reactor.observe(WriteTweetViewController.REPLY, handler: { (newState) -> () in
            self.performSegueWithIdentifier("reply", sender: self)
        }))
        keys.append(reactor.observe(TWEETS, handler: { (newState) -> () in
            self.tableView.reloadData()
        }))
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        reactor.unobserve(keys)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath) as! TweetView
        let baseGetter = reactor.evaluateToSwift(DETAIL_SOURCE) as! String == "timeline" ? TIMELINE : TWEETS
        let index = reactor.evaluateToSwift(DETAIL_INDEX) as! Int
        cell.tweet = reactor.evaluate(baseGetter.extendKeyPath([index]))
        return cell
    }
}