//
//  MenuViewController.swift
//  twitter
//
//  Created by Jim Cai on 5/3/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileDelegate {
    @IBOutlet weak var contentView: UIView!

    var contentViewController: UIViewController?
    let heightConstant = CGFloat(200.0)
    var onPosition = CGPoint(x: 50.0, y: 200.0)
    var offPosition = CGPoint(x: -350, y: 200.0)
    var startingPoint : CGPoint!
    var menuVisible = false

    @IBOutlet weak var navBarTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTable.delegate = self
        navBarTable.dataSource = self
//        activeViewController =  storyboard?.instantiateViewControllerWithIdentifier("Tweets") as TweetsViewController
        setTweetActiveController("Tweets")
        self.view.bringSubviewToFront(navBarTable)
    }

    func moveInMenu(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.navBarTable.center = self.onPosition
            }) { (completed:Bool) -> Void in
                
        }
    }
    
    
    func setProfileActiveController(user: User){
        var profileController = storyboard?.instantiateViewControllerWithIdentifier("Profile") as ProfileViewController!
        profileController.user = user

        activeViewController = profileController
        profileController.loadPage()
        moveOutMenu()
    }

    
    
    func setTweetActiveController(id: String){

        var tweetsController = storyboard?.instantiateViewControllerWithIdentifier("Tweets") as TweetsViewController!
        if id == "Mentions"{
            tweetsController.mentions = true
        }
        tweetsController.delegate = self
        activeViewController = tweetsController
        tweetsController.refreshData()
        moveOutMenu()

    }
    
    
    
    func profileDelegate(tweetsController: TweetsViewController, user: User) {
        setProfileActiveController(user)
    }
    
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = contentView.bounds
            contentView.addSubview(activeVC.view)

            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
    }
    
    func moveOutMenu(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.navBarTable.center = self.offPosition
            }) { (completed:Bool) -> Void in
               
                
        }
//        println("moving out")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuTableViewCell
        switch(indexPath.row){
        case 0:
            cell.menuLabel.text = "Home"
            break
        case 1:
            cell.menuLabel.text = "Me"
            break
        default:
            cell.menuLabel.text = "@Mentions"
            break
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row){
        case 0:
            setTweetActiveController("Tweets")
            break
        case 1:
            setProfileActiveController(User.currentUser!)
            break
        default:
            setTweetActiveController("Mentions")
            break
        }
        
        //self.performSegueWithIdentifier("TweetSegue", sender: self)
    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            self.startingPoint = point
            /*
            var imageView = sender.view as UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newFaceOriginalCenter = newlyCreatedFace.center
            let recognizer = UIPinchGestureRecognizer(target: self, action:"onFacePinch:")
            newlyCreatedFace.addGestureRecognizer(recognizer)
            newlyCreatedFace.userInteractionEnabled = true
            */
        } else if sender.state == UIGestureRecognizerState.Changed {
            navBarTable.center = CGPoint(x: self.startingPoint.x + translation.x, y: self.heightConstant)
            //            navBarTable.center = CGPoint(x: originalTrayCenter.x + translation.x, y: originalTrayCenter.y)
          //  println(navBarTable.center)
            /*
            newlyCreatedFace.center = CGPoint(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
            */
        } else if sender.state == UIGestureRecognizerState.Ended {
            if point.x - startingPoint.x > 0{
                moveInMenu()
            }else{
                moveOutMenu()
            }
            
        }

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
