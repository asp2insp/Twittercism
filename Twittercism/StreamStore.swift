//
//  StreamStore.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

class StreamStore : Store {
    override func initialize() {
        self.on("setTweets", handler: { (state, new, action) -> Immutable.State in
            return Immutable.toState(new as! AnyObject)
        })
    }
    
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
}