//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/14/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit
import AFNetworking


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tabelView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.estimatedRowHeight = 120
        
        
        TwitterClient.sharedInstance.homeTimelineWithCompletionParams(nil, completion: { (tweets, error) -> () in
            if let tweets = tweets {
                self.tweets = tweets
                self.tabelView.reloadData()
            }
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
        let url = NSURL(string: tweets[indexPath.row].user.profileImageUrl!);
        
        cell.profilePicture.setImageWithURL(url!)
        cell.userName.text = tweets[indexPath.row].user.name
        cell.tweetText.text = tweets[indexPath.row].text
        cell.timeStamp.text = tweets[indexPath.row].displayCreateAt
        cell.retweetCount.text = String(tweets[indexPath.row].retweetCount)
        cell.retweet.selected = tweets[indexPath.row].retweeted
        cell.favorite.selected = tweets[indexPath.row].favorited
        cell.favoriteCount.text = String(tweets[indexPath.row].favoritesCount)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tweetCellRetweet(tweetcell: TweetCell) {

        if let indexPath = tabelView.indexPathForCell(tweetcell) {
            let tweet = tweets[indexPath.row]
            let id = tweet.id
            TwitterClient.sharedInstance.retweetWithId(id, completion: { tweet, _ in
                if let tweet = tweet {
                    if let index = self.tweets.indexOf({ (tweet) -> Bool in
                        id == tweet.id
                    }) {
                        self.tweets[index] = tweet
                        self.tabelView.reloadData()
                    }
                }
            })
        }
        
    }
    
    func tweetCellFavorite(tweetCell: TweetCell) {
        if let indexPath = tabelView.indexPathForCell(tweetCell) {
            let tweet = tweets[indexPath.row]
            let id = tweet.id
            TwitterClient.sharedInstance.favoriteWithId(id, completion: { tweet, _ in
                if let tweet = tweet {
                    if let index = self.tweets.indexOf({ (tweet) -> Bool in
                        id == tweet.id
                    }) {
                        self.tweets[index] = tweet
                        self.tabelView.reloadData()
                    }
                }
            })
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
