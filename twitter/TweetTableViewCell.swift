//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by Jim Cai on 4/26/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

protocol ReplyDelegate{
    func replyDelegate(tweetTableViewCell : TweetTableViewCell, tweet: Tweet)
}

protocol ProfilePicDelegate{
    func profilePicDelegate( tweetTableViewCell : TweetTableViewCell, user: User)
}

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    @IBOutlet weak var tweetMessage: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var delegate: ReplyDelegate?
    var pdelegate: ProfilePicDelegate?
    var tweet: Tweet?
    
    @IBAction func onReply(sender: AnyObject) {
       delegate?.replyDelegate(self, tweet: tweet!)
    }
    
    

    @IBAction func onTapPicture(sender: AnyObject) {
        pdelegate?.profilePicDelegate(self, user: tweet!.user!)
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !retweetButton.selected{
            TwitterClient.sharedInstance.retweetMessage((tweet?.id)!)
            retweetButton.selected = true
        }
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userName.preferredMaxLayoutWidth  = self.userName.frame.size.width;
        self.twitterName.preferredMaxLayoutWidth  = self.twitterName.frame.size.width;
        self.tweetMessage.preferredMaxLayoutWidth  = self.tweetMessage.frame.size.width;
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.userName.preferredMaxLayoutWidth  = self.userName.frame.size.width;
        self.twitterName.preferredMaxLayoutWidth  = self.twitterName.frame.size.width;
        self.tweetMessage.preferredMaxLayoutWidth  = self.tweetMessage.frame.size.width;

        
    }
}
