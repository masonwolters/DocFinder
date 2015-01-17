//
//  MainViewController.swift
//  
//
//  Created by Russell Ladd on 1/17/15.
//
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func newUserButtonTouchUpInside() {
        
        let signUpViewController = PFSignUpViewController()
        
        presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func existingUserButtonTouchUpInside() {
        
        let logInViewController = PFLogInViewController()
        
        presentViewController(logInViewController, animated: true, completion: nil)
    }
}
