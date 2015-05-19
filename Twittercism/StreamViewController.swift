//
//  ViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class StreamViewController : UITableViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Bind to reactor
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return TweetCell()
    }
}