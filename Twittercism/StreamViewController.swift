//
//  ViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import UIKit

class StreamViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var reactor : Reactor! = Reactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 160;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Bind to reactor
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath) as! TweetView
        cell.tweet = reactor.evaluate(Getter(keyPath: ["data", "tweets", indexPath.row]))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TweetDetail", sender: self)
    }
}