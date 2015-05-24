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
    
    var delegate : TweetActionDelegate? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let v = NSBundle.mainBundle().loadNibNamed("ActionsBar", owner: self, options: nil).first as! UIView
        self.addSubview(v);
    }
    
    @IBAction func doAction(sender: UIButton) {
        switch sender {
        case starButton:
            self.delegate?.onFavorite()
        case retweetButton:
            self.delegate?.onRetweet()
        case replyButton:
            self.delegate?.onReply()
        default:
            NSLog("Unknown Sender")
        }
    }
}

public protocol TweetActionDelegate {
    func onFavorite()
    func onRetweet()
    func onReply()
}
