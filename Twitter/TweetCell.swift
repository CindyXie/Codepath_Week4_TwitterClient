//
//  TweetCell.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/14/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweet: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
   
    weak var delegate: TweetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.image = nil
    }

    @IBAction func retweetAction(sender: AnyObject) {
        delegate?.tweetCellRetweet(self)
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        delegate?.tweetCellFavorite(self)
    }
    
}

protocol TweetCellDelegate: class {
    func tweetCellRetweet(tweetcell: TweetCell)
    func tweetCellFavorite(tweetCell: TweetCell)
}
