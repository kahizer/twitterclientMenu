//
//  MentionsViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 11/6/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    
    @IBOutlet weak var mentionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mentionsTableView.dataSource = self
        self.mentionsTableView.delegate = self
        
        self.mentionsTableView.rowHeight = UITableViewAutomaticDimension
        self.mentionsTableView.estimatedRowHeight = 120
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let twittercolor = UIColor.init(red: 85/250.0, green: 172/250.0, blue: 238/50.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twittercolor
        
        getTweets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTweets(){
        TwitterClient.sharedInstance?.getMentions( success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.mentionsTableView.reloadData()
            
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
