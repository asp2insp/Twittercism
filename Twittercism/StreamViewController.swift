//
//  ViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class StreamViewController : UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 176.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Bind to reactor
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("twittercism.tweetcell") as! TweetCell
        cell.tweet = Immutable.State.None
        return cell
    }
}