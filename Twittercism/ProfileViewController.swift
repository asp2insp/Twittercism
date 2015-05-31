//
//  ProfileViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

let TIMELINE = Getter(keyPath: ["timeline", "tweets"])

class ProfileViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var loginButtonPlaceholder: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: TWTRLogInButton!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    let BASE_HEADER_HEIGHT : CGFloat = 200.0
    
    
    @IBOutlet weak var headerBackground: UIImageView!
    @IBOutlet weak var headerProfile: UIImageView!
    @IBOutlet weak var headerDisplayName: UILabel!
    @IBOutlet weak var headerHandle: UILabel!
    @IBOutlet weak var headerStats: UISegmentedControl!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let TARGET_TIMELINE = Getter(keyPath: ["timeline", "target_screen_name"])
    let PROFILE = Getter(keyPath: ["timeline", "user"])
    
    var reactor : Reactor!
    var keys : [UInt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = TwitterApi.sharedInstance.reactor
        reactor.dispatch("setTimelineUser", payload: "me")
        tableView.registerNib(UINib(nibName: "Tweet", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweet")
        
//        headerView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        tableView.tableHeaderView = nil
//        tableView.addSubview(headerView)
//        let views = [
//            "tableView": tableView,
//            "headerView": headerView
//        ]
//        tableView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[headerView(==tableView)]|", options: nil, metrics: nil, views: views))
//        headerHeight.constant = BASE_HEADER_HEIGHT
//        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight.constant)
        
        loginButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            if error != nil {
                NSLog(error.localizedDescription)
            } else {
                self.placeLogoutButton()
                NSLog("Logged in \(session.userName)!")
            }
        })
        loginButton.center = CGPointMake(self.view.center.x, loginButtonPlaceholder.bounds.size.height / 2);
        loginButtonPlaceholder.addSubview(loginButton)

        if Twitter.sharedInstance().session() != nil {
            placeLogoutButton()
            NSLog("Found account for \(Twitter.sharedInstance().session().userName)")
        } else {
            placeLoginButton()
        }
        logoutButton.layer.cornerRadius = 5;
        logoutButton.clipsToBounds = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        TwitterApi.loadTimeline(reactor.evaluateToSwift(TARGET_TIMELINE) as! String)
        super.viewDidAppear(animated)
        keys.append(reactor.observe(TIMELINE, handler: { (newState) -> () in
            self.tableView.reloadData()
        }))
        keys.append(reactor.observe(PROFILE, handler: { (newState) -> () in
            self.refreshProfile()
        }))
//        keys.append(reactor.observe(WriteTweetViewController.REPLY, handler: { (newState) -> () in
//            self.performSegueWithIdentifier("reply", sender: self)
//        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        reactor.unobserve(keys)
    }
    
    func refreshProfile() {
        let profile = reactor.evaluate(PROFILE)
        let screenName = profile.getIn(["screen_name"]).toSwift() as? String ?? "unknown"
        headerHandle.text = "@\(screenName)"
        
        headerDisplayName.text = profile.getIn(["name"]).toSwift() as? String ?? "Unknown"
        if let profileUrl = profile.getIn(["profile_image_url_https"]).toSwift() as? String {
            headerProfile.setImageWithURL(NSURL(string: profileUrl))
        }
        if let backgroundUrl = profile.getIn(["profile_background_image_url_https"]).toSwift() as? String {
            headerBackground.setImageWithURL(NSURL(string: backgroundUrl))
        }
        
        let tweetCount = profile.getIn(["statuses_count"]).toSwift() as? Int ?? 0
        let followingCount = profile.getIn(["friends_count"]).toSwift() as? Int ?? 0
        let followersCount = profile.getIn(["followers_count"]).toSwift() as? Int ?? 0
        
        headerStats.removeAllSegments()
        headerStats.insertSegmentWithTitle("\(followersCount) FOLLOWERS", atIndex: 0, animated: false)
        headerStats.insertSegmentWithTitle("\(followingCount) FOLLOWING", atIndex: 0, animated: false)
        headerStats.insertSegmentWithTitle("\(tweetCount) TWEETS", atIndex: 0, animated: false)
    }
    
    func fetchTimeline() {
        TwitterApi.loadTimeline(reactor.evaluateToSwift(TARGET_TIMELINE) as! String)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Infinite scroll
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.evaluate(TIMELINE).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath) as! TweetView
        cell.tweet = reactor.evaluate(TIMELINE.extendKeyPath([indexPath.row]))
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reactor.dispatch("setDetail", payload: [
                "index": indexPath.row,
                "source": "timeline"
            ])
        self.performSegueWithIdentifier("TweetDetail", sender: self)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let offset = tableView.contentOffset.y
//        
//        if offset < -BASE_HEADER_HEIGHT {
//            headerHeight.constant = BASE_HEADER_HEIGHT - offset
////            headerView.setNeedsLayout()
//            tableView.setNeedsLayout()
//            headerView.setNeedsLayout()
//        } else {
//            headerHeight.constant = BASE_HEADER_HEIGHT
//        }
    }

    
    // LOGIN/LOGOUT BUTTONS --- MOVE TO HAMBURGER
    func placeLogoutButton() {
        loginButton.hidden = true
        logoutButton.hidden = false
    }
    
    @IBAction func doLogout(sender: UIButton) {
        Twitter.sharedInstance().logOut()
        NSLog("Logged out")
        placeLoginButton()
    }
    
    func placeLoginButton() {
        logoutButton.hidden = true
        loginButton.hidden = false
    }
}