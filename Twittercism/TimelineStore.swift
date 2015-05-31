//
//  TimelineStore.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/25/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

class TimelineStore : Store {
    override func initialize() {
        self.on("setTimelineUser", handler: { (state, screenName, action) -> Immutable.State in
            return state.setIn(["target_screen_name"], withValue: Immutable.toState(screenName as! String))
        })
        self.on("setUserProfile", handler: { (state, profile, action) -> Immutable.State in
            return state.setIn(["user"], withValue: Immutable.toState(profile as! AnyObject))
        })
        self.on("setTimelineTweets", handler: { (state, new, action) -> Immutable.State in
            return state.setIn(["tweets"], withValue: Immutable.toState(new as! AnyObject))
        })
        self.on("toggleTimelineFavoriteTweet", handler: {(state, tweetId, action) -> Immutable.State in
            return state.map({(one, key) -> Immutable.State in
                if one.getIn(["id_str"]).toSwift() as! String == tweetId as! String {
                    let currentlyFavorited = one.getIn(["favorited"]).toSwift() as! Bool
                    let currentFavoriteCount = one.getIn(["favorite_count"]).toSwift() as! Int
                    let diff = currentlyFavorited ? -1 : 1
                    if currentlyFavorited {
                        TwitterApi.unfavoriteTweet(tweetId as! String)
                    } else {
                        TwitterApi.favoriteTweet(tweetId as! String)
                    }
                    return one.setIn(["favorited"], withValue: Immutable.toState(!currentlyFavorited)).setIn(["favorite_count"], withValue: Immutable.toState(currentFavoriteCount + diff))
                } else {
                    return one
                }
            })
        })
        self.on("retweetFromTimeline", handler: {(state, tweetId, action) -> Immutable.State in
            return state.map({(one, key) -> Immutable.State in
                if one.getIn(["id_str"]).toSwift() as! String == tweetId as! String {
                    let currentlyRetweeted = one.getIn(["retweeted"]).toSwift() as! Bool
                    
                    if !currentlyRetweeted {
                        TwitterApi.retweet(tweetId as! String)
                        let newCount = one.getIn(["retweet_count"]).toSwift() as! Int + 1
                        return one.setIn(["retweeted"], withValue: Immutable.toState(true)).setIn(["retweet_count"], withValue: Immutable.toState(newCount))
                    }
                }
                return one
            })
        })
    }

    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
}