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
    
    // MARK: Window
    
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    // MARK: View controllers
    
    let tabBarController = UITabBarController()
    
    let doctorNavigationController = UINavigationController()
    let doctorLogInViewController = DoctorLogInViewController(nibName: "DoctorLogInViewController", bundle: nil)
    
    let clinicNavigationController = UINavigationController()
    let clinicMapViewController = ClinicMapViewController(nibName: "ClinicMapViewController", bundle: nil)
    
    // MARK: Life cycle
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("CdmE4AzemBZxYoogBlCCaEOrnv3w9E3s8jGqaHtn", clientKey: "1pVBUqEJ90BwnwL7cjUGVgx9Cau2KaUaM6egj0u2")
        
        doctorNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .Contacts, tag: 0)
        doctorNavigationController.viewControllers = [doctorLogInViewController]
        
        clinicNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .Search, tag: 0)
        clinicNavigationController.viewControllers = [clinicMapViewController]
        
        tabBarController.viewControllers = [doctorNavigationController, clinicNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        
        
        return true
    }
}
