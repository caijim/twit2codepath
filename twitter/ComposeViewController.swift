//
//  ComposeViewController.swift
//  twitter
//
//  Created by Jim Cai on 4/26/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    var user: User?    
    
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var realName: UILabel!
    var replyTweet : Tweet?
    var replyMode  = false
    
    @IBOutlet weak var profilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var cur = User.currentUser        
        realName.text = user?.name
        var twittername = user?.screenname as String?
        let joined = "@" + twittername!
        twitterName.text =  joined
        var url = user?.profileImageUrl
        profilePic.setImageWithURL(NSURL(string:url!)!)
        textBox.delegate = self
        
        if replyMode{
            textBox.text = "@" + (replyTweet?.user?.screenname)! + " "
            textBox.textColor = UIColor.blackColor()

            
            counter.text = "\(140-textBox.text.utf16Count)"
        }else{
            counter.text = "140"
        }
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if !replyMode{
            textBox.text = ""
            textBox.textColor = UIColor.blackColor()
        }
        
    }
    
    func textViewDidChange(textView: UITextView) {
        counter.text = "\(140-textBox.text.utf16Count)"
    }
    
  
    @IBAction func onCancel(sender: AnyObject) {
        self.textBox.text = ""
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onTweet(sender: AnyObject) {
        if replyMode{
            TwitterClient.sharedInstance.replyMessage(textBox.text, id: (replyTweet?.id)!)
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            TwitterClient.sharedInstance.tweetMessage(textBox.text)
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
  
    /*
    // MARK: - Navigatio

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
