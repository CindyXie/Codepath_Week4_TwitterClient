//
//  TwitterClient.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/8/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import BDBOAuth1Manager
import AFNetworking

let twitterConsumerKey = "fTbYY38yeSJoESGxxYgBBrJgy"
let twitterConsumerSecret = "u8vurZdjBhuD6wyIwAyqeBbjaz1b8qu5Zo8uGEACz1xgMUS4yR"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}