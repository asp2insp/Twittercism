//
//  DrawerViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/31/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

class DrawerViewController : UIViewController {
    
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var timelineButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var viewControllers : [String: UIViewController] = [:]
    var reactor : Reactor!
    
    var activeViewController : UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                if oldVC == activeViewController {
                    return
                }
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.frame = self.containerView.bounds
                self.containerView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        populateViewController("Timeline")
        populateViewController("Profile")
    }
    
    override func viewDidLoad() {
        reactor = TwitterApi.sharedInstance.reactor
        activeViewController = viewControllers["drawer_Timeline"]
    }
    
    func populateViewController(navName: String) {
        self.performSegueWithIdentifier("drawer_\(navName)", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.viewControllers[segue.identifier!] = segue.destinationViewController as? UIViewController
    }
    
    @IBAction func didSelectNavigationItem(sender: UIButton) {
        switch sender {
        case profileButton:
            reactor.dispatch("setTimelineUser", payload: "me")
        default:
            break
        }
        self.activeViewController = viewControllers["drawer_\(sender.currentTitle!)"]
    }
}