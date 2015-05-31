//
//  WriteTweetStore.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

let CURRENT_TAB = Getter(keyPath: ["ui", "currentTab"])

class UIStore : Store {
    override func initialize() {
        self.on("setReply", handler: {(state, replyId, action) -> Immutable.State in
            return state.setIn(["replyId"], withValue: Immutable.toState(replyId as! String))
        })
        self.on("setDetail", handler: {(state, detail, action) -> Immutable.State in
            return state.setIn(["detail"], withValue: Immutable.toState(detail as! AnyObject))
        })
        self.on("setTab", handler: {(state, name, action) -> Immutable.State in
            return state.setIn(["currentTab"], withValue: Immutable.toState(name as! AnyObject))
        })
    }
    
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
}