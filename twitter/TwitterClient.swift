//
//  TwitterClient.swift
//  twitter
//
//  Created by Jim Cai on 4/26/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

let twitterConsumerKey="ES8MoGrEbtLWD0MNxBPltOvUs"
let twitterConsumerSecret = "ODfaurDfz0Ze6nKBaWAB8WH7zgs7VAGqE8LAtG66uvXYiIQ83W"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    

    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
   
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("got access token")

            
            
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user                
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)                
                }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                     self.loginCompletion?(user:nil, error: error)
            })
            
            
            
            }) { (error: NSError!) -> Void in
                println("failed access token")
                self.loginCompletion?(user:nil, error: error)
        }
        
        
    }
    
    func mentionsTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()){
        GET("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get home timeline")
                println("\(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    
    
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()){
       GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
        completion(tweets: tweets, error: nil)
        }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("failed to get home timeline")
            println("\(error)")
            completion(tweets: nil, error: error)
        })
    }
    
    
    func tweetMessage(text:String){
        var params = NSMutableDictionary()
        params["status"] = text
        POST("1.1/statuses/update.json", parameters: params, success: nil, failure:nil)
    }
    
    func replyMessage(text:String, id:String){
        var params = NSMutableDictionary()
        params["status"] = text
        params["in_reply_to_status_id"] = id
        POST("1.1/statuses/update.json", parameters: params, success: nil, failure:nil)
    }
    
    func favoriteMessage(id:String){
        var params = NSMutableDictionary()
        params["id"] = id
        POST("1.1/favorites/create.json", parameters: params, success: nil, failure:nil)
    }
    
    func unfavoriteMessage(id:String){
        var params = NSMutableDictionary()
        params["id"] = id
        POST("1.1/favorites/destroy.json", parameters: params, success: nil, failure:nil)
    }
    
    
    
    func retweetMessage(id:String){
        var params = NSMutableDictionary()
        params["id"] = id
        var url = "1.1/statuses/retweet/\(id).json"
        POST(url, parameters: params, success: nil, failure:{ (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("failed to retweet")
            println("\(error)")
        })
    }
    
    
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //fetch request token & redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            //println("GOt the request token")
            var authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                println("failed to get request token")
                self.loginCompletion?(user:nil, error: error)
        }
        
        
    }
}
