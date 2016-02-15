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
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithCompletionParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
            print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterexercise://oauth"), scope: nil, success: {
            (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            })
            {(error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user:nil, error: error)
        }
    }
    
    func openURL(url:NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential (queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the Access Token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    self.loginCompletion?(user: user, error:nil)
                    
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting user")
                })
            
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user:nil, error: error)

        }

    }
    
}