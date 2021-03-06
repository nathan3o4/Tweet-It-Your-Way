//
//  User.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/17/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import Foundation

class User {
  var name:                   String?
  var screenname:             String?
  var profileImageUrl:        String?
  var highResProfileImageUrl: String?
  var headerImageUrl:         String?
  var tagLine:                String?
  var followersCount:         Int?
  var followingCount:         Int?
  var tweetCount:             Int?
  var dictionary:             NSDictionary?
  
  init(dict: NSDictionary?) {
    dictionary             = dict
    name                   = dict?["name"] as? String
    screenname             = dict?["screen_name"] as? String
    profileImageUrl        = dict?["profile_image_url"] as? String
    headerImageUrl         = dict?["profile_banner_url"] as? String
    tagLine                = dict?["description"] as? String
    followersCount         = dict?["followers_count"] as? Int
    followingCount         = dict?["friends_count"] as? Int
    tweetCount             = dict?["statuses_count"] as? Int
    highResProfileImageUrl = profileImageUrl?.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
  }
  
  static var _currentUser: User?
  
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let defaults = NSUserDefaults.standardUserDefaults()
        let userData = defaults.objectForKey("currentUserData") as? NSData
        if let userData = userData {
          let dict = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])
          _currentUser = User(dict: dict as? NSDictionary)
        }
      }
      return _currentUser
    }
    
    set(user) {
      let defaults = NSUserDefaults.standardUserDefaults()
      
      if let dict = user?.dictionary {
        let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: [])
        defaults.setObject(data, forKey: "currentUserData")
        defaults.synchronize()
      }
      else {
        defaults.setObject(nil, forKey: "currentUserData")
      }
    }
  }
  
  static let userDidLogoutNotificationString = "UserDidLogout"
}