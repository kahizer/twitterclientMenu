//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 11/5/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var userFullName: UILabel!
    
    @IBOutlet weak var userScreenName: UILabel!
    
    @IBOutlet weak var tweetsCount: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var currentUser : User!
    
    @IBOutlet weak var backgroundVIew: UIView!
    
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let twittercolor = UIColor.init(red: 85/250.0, green: 172/250.0, blue: 238/50.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twittercolor
        
        backgroundVIew.backgroundColor = twittercolor
        
        self.tweetsTableView.delegate = self
        self.tweetsTableView.dataSource = self
        
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 120
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        
        loadDisplay()
        GetTweets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDisplay(){
        //self.currentUser = User.currentUser;
        
        if self.currentUser == nil{
            self.currentUser = User.currentUser
        }
        
        if self.currentUser != nil {
            
            profileImageView.setImageWith(self.currentUser.profileUrl as! URL)
            backgroundImageView.setImageWith(self.currentUser.backgroundImageUrl as! URL)
            userFullName.text = self.currentUser.name as? String
            var username = self.currentUser.screenname as? String
            userScreenName.text = "@" + username!
            if let tweetsCountsRaw = currentUser.tweetsCount {
                if (tweetsCountsRaw > 1000000){
                    let countk = Float (tweetsCountsRaw) / 1000000
                    tweetsCount.text = String(format: "%.1f", countk) + "M"
                } else if(tweetsCountsRaw > 1000){
                    let countk = Float (tweetsCountsRaw) / 1000
                    tweetsCount.text = String(format: "%.1f", countk) + "k"
                    
                } else {
                    tweetsCount.text = String(tweetsCountsRaw)
                }
            }
            
            if let followingCountRaw = currentUser.followingCount {
                if (followingCountRaw > 1000000){
                    let countk = Float (followingCountRaw) / 1000000
                    followingCountLabel.text = String(format: "%.1f", countk) + "M"
                } else if(followingCountRaw > 1000){
                    let countk = Float (followingCountRaw) / 1000
                    followingCountLabel.text = String(format: "%.1f", countk) + "K"
                    
                } else {
                    followingCountLabel.text = String(followingCountRaw)
                }
                
                //followingCountLabel.text = String(followingCountRaw)
            }
            
            if let followersCountRaw = currentUser.followersCount {
                if (followersCountRaw > 1000000){
                    let countk = Float (followersCountRaw) / 1000000
                    followersCountLabel.text = String(format: "%.1f", countk) + "M"
                } else if(followersCountRaw > 1000){
                    let countk = Float (followersCountRaw) / 1000
                    followersCountLabel.text = String(format: "%.1f", countk) + "K"
                    
                } else {
                    followersCountLabel.text = String(followersCountRaw)
                }
                //followersCountLabel.text = String(followersCountRaw)
            }
        }
    }
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        self.dismiss(animated: true) {
           
        }
    }
    
    
    func GetTweets(){
        TwitterClient.sharedInstance?.userTimeline(userid: self.currentUser.id!, username: self.currentUser.screenname as! String, success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            
            }, failure: { (error:Error) in
                print(error.localizedDescription)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.indexNumber = indexPath.row
        cell.tweet = tweets[indexPath.row]
        //cell.delegate = self
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
