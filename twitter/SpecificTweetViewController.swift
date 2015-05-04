//
//  SpecificTweetViewController.swift
//  twitter
//
//  Created by Jim Cai on 4/26/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

class SpecificTweetViewController: UIViewController {

    @IBOutlet weak var numberRetweets: UILabel!
    @IBOutlet weak var numberFavoties: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var twittername: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        numberRetweets.text = "\(tweet!.retweet_count) RETWEETS"
        numberFavoties.text = "\(tweet!.favorites_count) FAVORITES"
        time.text = tweet!.createdAtString
        var twittname = tweet!.user?.screenname as String?
        let joined = "@" + twittname!
        twittername.text = joined
        name.text = tweet!.user?.name
        var url = tweet!.user?.profileImageUrl
        profilePic.setImageWithURL(NSURL(string:url!)!)
        text.text = tweet!.text
        var tapper = UITapGestureRecognizer(target: profilePic, action: Selector("onTap:"))
        profilePic.addGestureRecognizer(tapper)
        
        
        if tweet!.retweeted{
            retweetButton.selected = true
        }
        
        if tweet!.favorited{
            favoriteButton.selected = true
        }

        // Do any additional setup after loading the view.
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        println(sender)
    }
    

    @IBAction func onHome(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetMessage(tweet!.id!)
        retweetButton.selected = true
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        if favoriteButton.selected{
            TwitterClient.sharedInstance.unfavoriteMessage(tweet!.id!)
            favoriteButton.selected = false
        }else{
            TwitterClient.sharedInstance.favoriteMessage(tweet!.id!)
            favoriteButton.selected = true
        }
    }
    
    
    @IBAction func onReply2(sender: AnyObject) {
        onReply(sender)
    }
 
    @IBAction func onReply(sender: AnyObject) {
        self.performSegueWithIdentifier("ReplySegue", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ReplySegue"{
            var vc = segue.destinationViewController as ComposeViewController
            vc.user = User.currentUser
            vc.replyTweet = tweet
            vc.replyMode = true
        }
    }


}
