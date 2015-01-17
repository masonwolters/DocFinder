//
//  MainViewController.swift
//  
//
//  Created by Russell Ladd on 1/17/15.
//
//

import UIKit

class DoctorLogInViewController: UIViewController, PFLogInViewControllerDelegate {
    
    // MARK: Actions
    
    @IBAction func logInButtonTouchUpInside() {
        
        let logInViewController = PFLogInViewController()
        logInViewController.delegate = self
        
        presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    // MARK: PFLogInViewControllerDelegate
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        
        
    }
}
