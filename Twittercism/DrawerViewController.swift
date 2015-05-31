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
    @IBOutlet weak var leftSideConstraint: NSLayoutConstraint!

    @IBOutlet weak var timelineButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var viewControllers : [String: UIViewController] = [:]
    var reactor : Reactor!
    
    var drawerIsOpen : Bool {
        return leftSideConstraint.constant > 0
    }
    
    var activeViewController : UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                if oldVC == activeViewController {
                    return
                }
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    oldVC.view.alpha = 0.0
                }, completion: { (success) -> Void in
                    oldVC.willMoveToParentViewController(nil)
                    oldVC.view.removeFromSuperview()
                    oldVC.removeFromParentViewController()
                })

            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.alpha = 0
                newVC.view.frame = self.containerView.bounds
                self.containerView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    newVC.view.alpha = 1.0
                    return
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        populateViewController("Timeline")
        populateViewController("Profile")
    }
    
    func openDrawer() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.leftSideConstraint.constant = 84
            self.containerView.layoutIfNeeded()
        })
    }
    
    
    @IBAction func handlePanForDrawer(sender: UIPanGestureRecognizer) {
        var point = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        let baseConstant : CGFloat = drawerIsOpen ? 84 : -16
        switch sender.state {
        case .Began, .Changed:
            leftSideConstraint.constant = min(84, max(-16, baseConstant + point.x))
        case .Ended, .Cancelled:
            if velocity.x > 0 {
                openDrawer()
            } else {
                closeDrawer()
            }
        case .Failed, .Possible:
            closeDrawer()
        }
    }
    
    func closeDrawer() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.leftSideConstraint.constant = -16
            self.containerView.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        reactor = TwitterApi.sharedInstance.reactor
        activeViewController = viewControllers["drawer_Timeline"]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        openDrawer()
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
        closeDrawer()
    }
}