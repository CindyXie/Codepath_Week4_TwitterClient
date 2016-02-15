//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/14/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit
import AFNetworking


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tabelView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.estimatedRowHeight = 120
        
        
        TwitterClient.sharedInstance.homeTimelineWithCompletionParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tabelView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tabelView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let url = NSURL(string: tweets![indexPath.row].user.profileImageUrl!);
        
        cell.profilePicture.setImageWithURL(url!)
        cell.userName.text = tweets![indexPath.row].user.name
        cell.tweetText.text = tweets![indexPath.row].text
        cell.timeStamp.text = tweets![indexPath.row].displayCreateAt
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
            
        }
        return 0
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
