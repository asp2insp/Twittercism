//
//  TwitterApi.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/18/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterApi {
    static let sharedInstance = TwitterApi()
    let reactor = Reactor()
    let timelineEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    let favoriteEndpoint = "https://api.twitter.com/1.1/favorites/create.json"
    let unfavoriteEndpoint = "https://api.twitter.com/1.1/favorites/destroy.json"
    let retweetEndpoint = "https://api.twitter.com/1.1/statuses/retweet/"
    let updateEndpoint = "https://api.twitter.com/1.1/statuses/update.json"

    
    init() {
        reactor.registerStore("stream", store: StreamStore())
        reactor.registerStore("ui", store: UIStore())
    }
    
    class func loadTweets() {
        sharedInstance.loadTweets()
    }
    
    func loadTweets() {
        let params = ["user_id": Twitter.sharedInstance().session().userID]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
                "GET", URL: timelineEndpoint, parameters: params,
                error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                    (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json : AnyObject? =
                    NSJSONSerialization.JSONObjectWithData(data,
                        options: nil,
                        error: &jsonError)
                    self.reactor.dispatch("setTweets", payload: json!)
                }
                else {
                    println("Error: \(connectionError)")
                    self.reactor.dispatch("setTweets", payload: [])
                }
            }
        }
        else {
            self.reactor.dispatch("setTweets", payload: [])
        }
    }
    
    class func favoriteTweet(id: String) {
        sharedInstance.favoriteTweet(id)
    }
    
    func favoriteTweet(id: String) {
        let params = ["id": id]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
            "POST", URL: favoriteEndpoint, parameters: params,
            error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    NSLog("Favorite success")
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }
    
    class func unfavoriteTweet(id: String) {
        sharedInstance.unfavoriteTweet(id)
    }
    
    func unfavoriteTweet(id: String) {
        let params = ["id": id]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
            "POST", URL: unfavoriteEndpoint, parameters: params,
            error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    NSLog("Unfavorite success")
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }

    class func retweet(id: String) {
        sharedInstance.retweet(id)
    }
    
    func retweet(id: String) {
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
            "POST", URL: "\(retweetEndpoint)\(id).json", parameters: [:],
            error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    NSLog("Retweet success")
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }

    class func tweet(content: String) {
        sharedInstance.tweet(content)
    }
    
    func tweet(content: String) {
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
            "POST", URL: updateEndpoint, parameters: ["status":content],
            error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    NSLog("Tweet success")
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }

}