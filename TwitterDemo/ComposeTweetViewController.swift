//
//  ComposeTweetViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/30/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var UserFullname: UILabel!
    
    @IBOutlet weak var userScreenName: UILabel!
    
    
    @IBOutlet weak var composeTextView: UITextView!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    let limitLength = 140
    
    var currentUser : User!
    
    var reply: Bool = false
    
    var replyId: Int!
    
    var replyScreenName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        composeTextView.delegate = self
        
        var twittercolor = UIColor.init(red: 85/250.0, green: 172/250.0, blue: 238/50.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twittercolor

        
//         TwitterClient.sharedInstance?.currentAccount(successs: { (usr:User) in
//            self.currentUser = usr
//            self.loadUsersInfo()
//            }, failure: { (error:NSError) in
//                print(error.localizedDescription)
//        })
//        
        self.currentUser = User.currentUser
        self.loadUsersInfo()
        
        
        
        if(self.reply == true){
            composeTextView.text = "@" + replyScreenName + " "
            
        }
        
        userImageView.layer.cornerRadius = 4
        userImageView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUsersInfo(){
        if currentUser != nil {
            UserFullname.text = currentUser.name as? String
            userScreenName.text = currentUser.screenname as? String
            userImageView.setImageWith(currentUser.profileUrl as! URL)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        characterCountLabel.text = String(140 - textView.text.characters.count) + " characters left"
        return textView.text.characters.count + (text.characters.count - range.length) <= 140
    
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true) { 
            
        }
    }
    

    @IBAction func onTweetButton(_ sender: AnyObject) {
        if(reply){
            TwitterClient.sharedInstance?.replyComposeTweet(status: composeTextView.text!, id: replyId, succedd: { (response:NSDictionary) in
                
                }, faliure: { (error:NSError) in
                    
            })
            
        } else {
           TwitterClient.sharedInstance?.composeTweet(status: composeTextView.text!)
            print("just tweetd " + composeTextView.text!)
        }
        
        dismiss(animated: true) { }
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
