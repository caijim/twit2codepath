//
//  ProfileViewController.swift
//  
//
//  Created by Jim Cai on 5/4/15.
//
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var realName: UILabel!
    @IBOutlet weak var profileBack: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPage(){
            numFollowers.text = String(user.followers)
            numFollowing.text = String(user.following)
            numTweets.text = String(user.totalTweets)
            twitterName.text = user.screenname
            realName.text = user.name
            var url = user.profileImageUrl
            profilePic.setImageWithURL(NSURL(string:url!)!)
            self.twitterName.preferredMaxLayoutWidth  = self.twitterName.frame.size.width;
            self.realName.preferredMaxLayoutWidth  = self.realName.frame.size.width;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
