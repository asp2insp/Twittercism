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

class ProfileViewController : UIViewController {
    @IBOutlet weak var loginButtonPlaceholder: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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