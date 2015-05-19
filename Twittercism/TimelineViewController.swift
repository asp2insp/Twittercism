//
//  TimelineViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

class TimelineViewController : UITableViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Bind to reactor
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: bind to tweet cell class
        return TweetCell()
    }
}