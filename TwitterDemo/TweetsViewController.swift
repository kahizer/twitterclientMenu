//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/28/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, myTableDelegate{

    var tweets: [Tweet]!
    var currentIndex: Int!
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let twittercolor = UIColor.init(red: 85/250.0, green: 172/250.0, blue: 238/50.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twittercolor

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refresh), for: UIControlEvents.valueChanged)
        tweetTableView.addSubview(refreshControl)
        
        self.tweetTableView.dataSource = self
        self.tweetTableView.delegate = self
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 120
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        GetTweets()
    }
 

    func refresh(){
        self.tweets = nil
        GetTweets()
        print("refreshing table view")
    }
    
    func GetTweets(){
        //TwitterClient.sharedInstance?.
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            for tweet in tweets{
                print(tweet.text)
            }
            
            self.tweetTableView.reloadData()
            }, failure: { (error:Error) in
                print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogout(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
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
        cell.delegate = self
        return cell
    }

    func myTableDelegate(index:Int) {
        self.currentIndex = index
        self.performSegue(withIdentifier: "tweetdetailnavigationcontroller", sender: nil)
        print("tapped and index number:" + String(index))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tweetdetailnavigationcontroller"){
            let navigationViewController = segue.destination as! UINavigationController
            let tweetviewcontroller = navigationViewController.topViewController as! TweeViewController
            tweetviewcontroller.currentTweet = tweets[self.currentIndex] as Tweet
        }
    }
}
