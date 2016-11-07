//
//  User.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/27/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class User: NSObject {
    var name : NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    var id : Int?
    var stringId : NSString?
    
    var backgroundImageUrl: NSURL?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        id = dictionary["id"] as? Int
        stringId = dictionary[""] as? String as NSString?
        
        let profileUrlString = dictionary["profile_image_url"] as? String//dictionary["profile_background_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileBackgroundUrlString = profileBackgroundUrlString{
            backgroundImageUrl = NSURL(string: profileBackgroundUrlString)
        }
        
        tagline = dictionary["description"] as? String as NSString?
    }
    
    static var _currentUser: User?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static let userDismissTweetCompose = "UserDismissTweetCompose"
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let  defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let  defaults = UserDefaults.standard
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options:[])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
