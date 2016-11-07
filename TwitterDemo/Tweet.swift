//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/27/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text : String?
    var timestamp: NSDate?
    var retweetCount : Int = 0
    var favoritesCount : Int = 0
    var id: Int?
    var idString: String!
    var retweeted : Bool = false
    
    var iretweeted : Bool = false
    var ifavorited : Bool = false
    
    var user : User!
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        idString = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        
        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        let userDictionary = dictionary["user"] as! NSDictionary
        if userDictionary != nil {
            self.user = User.init(dictionary: userDictionary)
            favoritesCount = (userDictionary["favourites_count"] as? Int) ?? 0
        }
        
    }
    
    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
