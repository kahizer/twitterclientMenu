//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/28/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "vWALCf5s6I0vZ2VVHLuNv1aqV", consumerSecret: "hL0JKRMtuUn7qKrEJO8aGt9FGT5v8wGgxutDh6GdXXfbLtk3mM")
    
    var loginSuccess: (() ->())?
    var loginFaliure: ((NSError) -> ())?
    
    func login(success: @escaping ()->(), failure: @escaping (NSError)-> ()) {
        loginSuccess = success
        loginFaliure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth") as URL!, scope: nil, success: { (requestToken:BDBOAuth1Credential?) in
            
            print("I got token")
            
            if let token = requestToken?.token {
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.openURL(url as URL)
            }
            
            }, failure: { (error:Error?) in
                print("Error: \(error?.localizedDescription)")
                self.loginFaliure?(error as! NSError)
        })

    }
    
    func handleOpenUrl(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (accessToke:BDBOAuth1Credential?) in
            print("I got access token")
            
            self.currentAccount(successs: { (user:User) in
                self.loginSuccess?()
                User.currentUser = user
                }, failure: { (error:NSError) in
                  self.loginFaliure?(error)
            })
            }, failure: { (error:Error?) in
                print("failed to get access token, error: \(error?.localizedDescription)")
                self.loginFaliure?(error as! NSError)
        })
        
    }
    
    func logout(){
        User._currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
            success(tweets)
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }

    func currentAccount(successs: @escaping (User) -> (), failure: @escaping (NSError) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            //print("account \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            successs(user)
            
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error as NSError)
        })
    }
    
    func composeTweet (status: String){
    
        let keys = ["status"]
        let params = NSDictionary.init(objects: [status], forKeys: keys as [NSCopying])
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
                print("tweet post response successfully")
                print(response)
            
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                print("something went wrong when posting...")
                print(error.localizedDescription)
            
        })
        //post("1.1/statuses/update.json", )
    }
    
    func replyComposeTweet (status: String, id: Int, succedd:@escaping (NSDictionary) -> (), faliure: @escaping (NSError) -> ()){
        let keys = ["status", "in_reply_to_status_id"]
        let params = NSDictionary.init(objects: [status, id], forKeys: keys as [NSCopying])
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            print("tweet post response successfully")
            print(response)
            succedd(response as! NSDictionary)
            
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                print("something went wrong when posting...")
                print(error.localizedDescription)
                faliure(error as NSError)
                
        })
        //post("1.1/statuses/update.json", )
    }
    
    func favoriteTweet(id:Int, succedd:@escaping (NSDictionary) -> (), faliure: @escaping (NSError) -> ()){
        let keys = ["id"]
        let params = NSDictionary.init(objects: [id], forKeys: keys as [NSCopying])
        post("1.1/favorites/create.json", parameters: params, success: { (response) in
            succedd((response as! NSDictionary))
            }, failure: { (operation, error) in
                print("error favoriting tweet: \(error.localizedDescription)")
                faliure(error as NSError)
        })
    }
    
    func unfavoriteTweet(id:Int, succedd:@escaping (NSDictionary) -> (), faliure: @escaping (NSError) -> ()){
        let keys = ["id"]
        let params = NSDictionary.init(objects: [id], forKeys: keys as [NSCopying])
        post("1.1/favorites/destroy.json", parameters: params, success: { (response) in
            succedd((response as! NSDictionary))
            }, failure: { (operation, error) in
                print("error unfavoriting tweet: \(error.localizedDescription)")
                faliure(error as NSError)
        })
    }
    
    func retweet(id:Int, idstr: String, succedd:@escaping (NSDictionary) -> (), faliure: @escaping (NSError) -> ()){
        let keys = ["id", "id_str"]
        let params = NSDictionary.init(objects: [id, idstr], forKeys: keys as [NSCopying])
        
        post("1.1/statuses/retweet/\(params.value(forKey: "id_str") as! String).json", parameters: params, success: { (response) in
            succedd((response as! NSDictionary))
            }, failure: { (operation, error) in
                print("error retweeting tweet: \(error.localizedDescription)")
                faliure(error as NSError)
        })
    }
    
    func unretweet(id:Int, idstr: String, succedd:@escaping (NSDictionary) -> (), faliure: @escaping (NSError) -> ()){
        let keys = ["id", "id_str"]
        let params = NSDictionary.init(objects: [id, idstr], forKeys: keys as [NSCopying])
        
        post("1.1/statuses/unretweet/\(params.value(forKey: "id_str") as! String).json", parameters: params, success: { (operation, response) in
            succedd((response as! NSDictionary))
            }, failure: { (operation, error) in
                print("error unretweeting tweet: \(error.localizedDescription)")
                faliure(error as NSError)
        })
    }
    
    func userTimeline(userid: Int, username: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        let keys = ["user_id"]
        let params = NSDictionary.init(objects: [userid], forKeys: keys as [NSCopying])
        get("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
            success(tweets)
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    func getMentions(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
            success(tweets)
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }

}
