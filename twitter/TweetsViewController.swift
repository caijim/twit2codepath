//
//  TweetsViewController.swift
//  twitter
//
//  Created by Jim Cai on 4/26/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit


protocol ProfileDelegate{
    func profileDelegate(tweetsController : TweetsViewController, user: User)
}


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReplyDelegate, ProfilePicDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var selectedTweet = -1
    var curTweet: Tweet?
    var replyMode = false
    var mentions = false
    var delegate: ProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 500
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func composeTweet(sender: AnyObject) {
        //self.performSegueWithIdentifier("ComposeSegue", sender: self)
        
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        User.currentUser?.logout()
    }
    
    func refreshData(){
        if mentions{
            TwitterClient.sharedInstance.mentionsTimelineWithCompletion(nil) { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
            }

        }else{
            TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }
    }
    
    
    func onRefresh() {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    func replyDelegate(tweetTableViewCell: TweetTableViewCell, tweet: Tweet) {
        curTweet = tweet
        replyMode = true
        //self.performSegueWithIdentifier("ComposeSegue", sender: self)
    }

    func profilePicDelegate(tweetTableViewCell: TweetTableViewCell, user: User) {
        delegate?.profileDelegate(self, user: user)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetTableViewCell
        cell.delegate = self
        cell.pdelegate = self
        var tweet = tweets![indexPath.row]
        cell.tweet = tweet
        cell.userName.text = tweet.user?.name
        var twittername = tweet.user?.screenname as String?
        let joined = "@" + twittername!
        cell.twitterName.text =  joined
        cell.tweetMessage.text = tweet.text
        var url = tweet.user?.profileImageUrl
        cell.profilePic.setImageWithURL(NSURL(string:url!)!)
        if tweet.favorited{
            cell.favoriteButton.selected = true
        }
        if tweet.retweeted{
            cell.retweetButton.selected = true
        }
        var now = NSDate()
        var difference = now.timeIntervalSinceDate(tweet.createdAt!)
        var hours = difference/3600
        if hours < 24{
            if hours<1{
                var minutes = hours*60
                var roundedMinutes = round(2.0 * minutes) / 2.0;
                cell.tweetTime.text = "\(roundedMinutes)m"
                
            }else{
                var roundedHours = round(2.0 * hours) / 2.0;
                cell.tweetTime.text = "\(roundedHours)h"
            }


        }else{
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            cell.tweetTime.text = formatter.stringFromDate(tweet.createdAt!)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = tweets{
            return tweets!.count
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTweet = indexPath.row
        //self.performSegueWithIdentifier("ProfileSegue", sender: self)
       // var specificTweet = tweets![indexPath.row]
        //delegate?.profileDelegate(self, user: specificTweet.user!)
    }
    
    override func viewWillAppear(animated: Bool) {
        replyMode = false
    }

    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ComposeSegue"{
            var vc = segue.destinationViewController as ComposeViewController
            vc.user = User.currentUser
            if replyMode{
                vc.replyTweet = curTweet
                vc.replyMode = true
            }
        }
        else if segue.identifier == "TweetSegue"{
            var vc = segue.destinationViewController as SpecificTweetViewController
            var tweet = tweets![selectedTweet]
            vc.tweet = tweet            
        }
    }


}
