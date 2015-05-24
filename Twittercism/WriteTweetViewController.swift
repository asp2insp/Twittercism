//
//  WriteTweetViewController.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

import UIKit

class WriteTweetViewController : UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Compose"
        var cancel = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        var send = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: "send")
        navigationItem.setRightBarButtonItem(send, animated: true)
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send() {
        NSLog("Sent!")
    }
}