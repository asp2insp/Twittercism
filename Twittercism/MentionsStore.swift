//
//  MentionsStore.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/31/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

class MentionsStore : Store {
    override func initialize() {
        self.on("setMentions", handler: { (state, mentions, action) -> Immutable.State in
            return Immutable.toState(mentions as! AnyObject)
        })
    }
    
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([])
    }
}