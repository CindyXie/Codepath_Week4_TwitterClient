//
//  Tweet.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/14/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String
    var user: User
    var text: String
    var createAtString: String
    var createAt: NSDate
    var displayCreateAt: String
    var retweetCount: Int
    var retweeted: Bool
    var favorited: Bool
    var favoritesCount: Int
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as! String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as! String
        createAtString = dictionary["created_at"] as! String
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        favoritesCount = dictionary["favorite_count"] as! Int
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:m:ss Z y"
        createAt = formatter.dateFromString(createAtString)!
        
        let displayFormatter = NSDateFormatter()
        displayFormatter.dateFormat = "MM/dd/yy"
        displayCreateAt = displayFormatter.stringFromDate(createAt)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}






