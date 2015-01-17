//
//  AppDelegate.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("CdmE4AzemBZxYoogBlCCaEOrnv3w9E3s8jGqaHtn", clientKey: "1pVBUqEJ90BwnwL7cjUGVgx9Cau2KaUaM6egj0u2")
        
        return true
    }
}
