//
//  WriteTweetStore.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

class UIStore : Store {
    override func initialize() {
        self.on("setReply", handler: {(state, replyId, action) -> Immutable.State in
            return state.setIn(["replyId"], withValue: Immutable.toState(replyId as! String))
        })
        self.on("setDetail", handler: {(state, detail, action) -> Immutable.State in
            return state.setIn(["detail"], withValue: Immutable.toState(detail as! AnyObject))
        })
        
    }
    
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
}