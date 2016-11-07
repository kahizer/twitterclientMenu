//
//  TweeViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/30/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class TweeViewController: UIViewController {

    var currentTweet : Tweet!
    
    //var currentUser : User!
    
    @IBOutlet weak var retweetedScreenName: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var userScreenNameLabel: UILabel!

    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetsCountLabel: UILabel!
    
    @IBOutlet weak var favoritesCount: UILabel!
    
    @IBOutlet weak var replyIconImageView: UIImageView!
    
    @IBOutlet weak var favoriteIconImageView: UIImageView!
    
    @IBOutlet weak var retweetIconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let twittercolor = UIColor.init(red: 85/250.0, green: 172/250.0, blue: 238/50.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twittercolor
       
        loadDisplay()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TweeViewController.onReplyIcon))
        replyIconImageView.addGestureRecognizer(tapGestureRecognizer)
        replyIconImageView.isUserInteractionEnabled = true
        
        let tapRetweetGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TweeViewController.onRetweetIcon))
        retweetIconImageView.addGestureRecognizer(tapRetweetGestureRecognizer)
        retweetIconImageView.isUserInteractionEnabled = true
        
        let tapFavoriteGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TweeViewController.onFavoriteIcon))
        favoriteIconImageView.addGestureRecognizer(tapFavoriteGestureRecognizer)
        favoriteIconImageView.isUserInteractionEnabled = true
        
        let tapImageUserGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweeViewController.onTapUserImage))
        userImageView.addGestureRecognizer(tapImageUserGestureRecognizer)
        userImageView.isUserInteractionEnabled = true
    }
    
    func onTapUserImage(){
        print("tapping on image")
        self.performSegue(withIdentifier: "profilesegue", sender: nil)
    }
    
    func onReplyIcon()
    {
        print("repying..")
        self.performSegue(withIdentifier: "composingsegue", sender: nil)
    }
    
    func onRetweetIcon()
    {
        if(currentTweet.iretweeted){
            currentTweet.iretweeted = false
            currentTweet.retweetCount -= 1
            TwitterClient.sharedInstance?.unretweet(id: currentTweet.id!, idstr: currentTweet.idString, succedd: { (response:NSDictionary) in
                
                }, faliure: { (error:NSError) in
            })

        } else {
            currentTweet.iretweeted = true
            currentTweet.retweetCount += 1
            TwitterClient.sharedInstance?.retweet(id: currentTweet.id!, idstr: currentTweet.idString, succedd: { (response:NSDictionary) in
            
            }, faliure: { (error:NSError) in
                        })
        }
        
        retweetsCountLabel.text = String(currentTweet.retweetCount)
        
    }
    
    func onFavoriteIcon()
    {
        print("favoriting..")
        
        if(currentTweet.ifavorited){
            currentTweet.ifavorited = false
            currentTweet.favoritesCount -= 1
            TwitterClient.sharedInstance?.favoriteTweet(id: currentTweet.id!, succedd: { (response:NSDictionary) in
                print("succesfully unfavorited tweet with id \(self.currentTweet.id)")
                }, faliure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        } else {
            currentTweet.ifavorited = true
            currentTweet.favoritesCount += 1
            TwitterClient.sharedInstance?.favoriteTweet(id: currentTweet.id!, succedd: { (response:NSDictionary) in
                print("succesfully favorited tweet with id \(self.currentTweet.id)")
                }, faliure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        }
        
        favoritesCount.text = String(currentTweet.favoritesCount)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDisplay(){
        
        userImageView.layer.cornerRadius = 4
        userImageView.clipsToBounds = true
        
        if(currentTweet != nil) {
            userImageView.setImageWith(currentTweet.user.profileUrl as! URL)
            userFullNameLabel.text = currentTweet.user.name as? String
            userScreenNameLabel.text = currentTweet.user.screenname as? String
        }
        
        tweetTextLabel.text = currentTweet.text
        
        if let ts = currentTweet.timestamp {
            timestampLabel.text = String(describing: ts)
        }
        
        
        retweetsCountLabel.text = String(currentTweet.retweetCount)
        favoritesCount.text = String(currentTweet.favoritesCount)
    }
    
    @IBAction func onHomeButton(_ sender: AnyObject) {
        dismiss(animated: true) {
        }
    }
    
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        print("replying...")
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "composingsegue"){
            let navigationViewController = segue.destination as! UINavigationController
            let composeTweetviewcontroller = navigationViewController.topViewController as! ComposeTweetViewController
            composeTweetviewcontroller.reply = true
            composeTweetviewcontroller.replyId = currentTweet.id
            composeTweetviewcontroller.replyScreenName = currentTweet.user.screenname as! String
        }
        
        if (segue.identifier == "profilesegue"){
            let navigationViewController = segue.destination as! UINavigationController
            let profileViewController = navigationViewController.topViewController as! ProfileViewController
            
            profileViewController.currentUser = currentTweet.user
        
        }
    }
 

}
