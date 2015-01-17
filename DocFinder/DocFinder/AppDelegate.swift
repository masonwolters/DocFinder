//
//  AppDelegate.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
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
        
        doctorNavigationController.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "DoctorIcon"), tag: 0)
        doctorNavigationController.viewControllers = [doctorLogInViewController]
        
        clinicNavigationController.tabBarItem = UITabBarItem(title: "Clinics", image: UIImage(named: "ClinicIcon"), tag: 0)
        clinicNavigationController.viewControllers = [clinicMapViewController]
        
        tabBarController.viewControllers = [doctorNavigationController, clinicNavigationController]
        tabBarController.delegate = self
        
        window.rootViewController = tabBarController
        window.tintColor = UIColor(red: 207.0/255.0, green: 029.0/255.0, blue: 012/255.0, alpha: 1.0)
        window.makeKeyAndVisible()
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        if let doctor = PFUser.currentUser() {
            doctorLogInViewController.showDoctorViewController(doctor, animated: false)
        }
        
        return true
    }
    
    // MARK: UITabBarControllerDelegate
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return tabBarController.selectedViewController != viewController
    }
}
