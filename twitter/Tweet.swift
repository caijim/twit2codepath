//
//  Tweet.swift
//  twitter
//
//  Created by Jim Cai on 4/26/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweeted = false
    var favorited = false
    var retweet_count = 0
    var favorites_count = 0
    var id:String?
    var followers = 0
    var following = 0
    var totaltweets = 0
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        retweeted = dictionary["retweeted"] as Bool
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        favorited = dictionary["favorited"] as Bool
        retweet_count = dictionary["retweet_count"] as Int
        favorites_count = dictionary["favorite_count"] as Int
        id = dictionary["id_str"] as? String
       
        
    }
    
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
