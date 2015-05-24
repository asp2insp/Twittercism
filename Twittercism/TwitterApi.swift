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
    let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
    let timelineEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    
    init() {
        reactor.registerStore("stream", store: StreamStore())
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
                    println(json)
                    self.reactor.dispatch("setTweets", payload: json!)
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