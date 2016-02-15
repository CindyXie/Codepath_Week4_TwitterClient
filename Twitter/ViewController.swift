//
//  ViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/8/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                //perform segur
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //handle login error
            }
            
        }
        
    }
    
}
