//
//  WriteTweetViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import TwitterKit
import UIKit

class WriteTweetViewController : UIViewController, UITextViewDelegate {
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var localizedName: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var textContent: UITextView!
    
    @IBOutlet weak var remainingLabel: UILabel!
    
    let reactor = TwitterApi.sharedInstance.reactor
    static let REPLY = Getter(keyPath: ["ui", "replyId"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = Twitter.sharedInstance().session()
        Twitter.sharedInstance().APIClient.loadUserWithID(session.userID, completion: { (user, error) -> Void in
            self.localizedName.text = user!.name
            self.handleLabel.text = "@\(user!.screenName)"
            self.profilePic.setImageWithURL(NSURL(string: user!.profileImageURL))
        })
        textContent.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Compose"
        var cancel = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        var send = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: "send")
        navigationItem.setRightBarButtonItem(send, animated: true)
        
        if let replyName = reactor.evaluate(WriteTweetViewController.REPLY).toSwift() as? String where !replyName.isEmpty {
            textContent.text = "@\(replyName) "
            reactor.dispatch("setReply", payload: "")
            self.textViewDidChange(textContent)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let length = count(textContent.text)
        if length >= 140 {
            textContent.text = textContent.text.substringToIndex(advance(textContent.text.startIndex, 139))
        }
        remainingLabel.text = "\(length)/140"
    }
    
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send() {
        TwitterApi.tweet(textContent.text)
        self.cancel()
    }
}