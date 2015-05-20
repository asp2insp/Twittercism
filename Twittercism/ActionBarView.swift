//
//  ActionBarView.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/19/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

class ActionBarView : UIView {
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    @IBAction func doAction(sender: UIButton) {
        switch sender {
        case starButton:
            NSLog("Star Button!")
        case retweetButton:
            NSLog("Retweet Button!")
        case replyButton:
            NSLog("Reply Button!")
        default:
            NSLog("Unknown Sender")
        }
    }
}