//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/14/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit
import AFNetworking


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, DetailPageViewControllerDelegate {
    
    var tweets: [Tweet] = []
    var maxId: String?
    var isLoadingData = false
    var isAtBottom = false
    
    @IBOutlet weak var tabelView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.estimatedRowHeight = 120
        tabelView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
        loadNextPage()

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
        let tweet = tweets[indexPath.row]
        cell.configure(tweet)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toDetailPage", sender: indexPath)
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
    
    func tweetCellDidTapProfileImage(tweetCell: TweetCell) {
        performSegueWithIdentifier("toProfilePage", sender: tweetCell)
    }

    func detailPageViewController(viewController: DetailPageViewController, tweetDidUpdate tweet: Tweet) {
        let id = tweet.id
        if let index = tweets.indexOf({ (tweet) -> Bool in
            id == tweet.id
        }) {
            self.tweets[index] = tweet
            self.tabelView.reloadData()
        }
        
    }
    
    func loadNextPage() {
        
        var params: NSDictionary? = nil
        if let id = maxId {
            params = ["max_id": id]
        }
        
        if isLoadingData {
            return
        }
        isLoadingData = true
        TwitterClient.sharedInstance.homeTimelineWithCompletionParams(params, completion: { (tweets, error) -> () in
            self.isLoadingData = false
            if let tweets = tweets {
                self.tweets += tweets
                if let tweet = tweets.first {
                    self.maxId = tweet.id
                }
                self.tabelView.reloadData()
            }
        })
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentSize.height >= scrollView.frame.height {
            if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
                if !isAtBottom {
                    isAtBottom = true
                    loadNextPage()
                }
            } else {
                isAtBottom  = false
            }

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailPage" {
            let destinationVC = segue.destinationViewController as! DetailPageViewController
            destinationVC.delegate = self
            let indexPath = sender as! NSIndexPath
            let tweet = tweets[indexPath.row]
            destinationVC.tweet = tweet
            
        }
        
        if segue.identifier == "toProfilePage" {
            let cell = sender as! TweetCell
            let indexPath = self.tabelView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.tweet = tweet
        }

        
    }

}
