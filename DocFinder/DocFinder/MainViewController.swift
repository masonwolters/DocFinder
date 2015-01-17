//
//  MainViewController.swift
//  
//
//  Created by Russell Ladd on 1/17/15.
//
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    
    @IBAction func existingUserButtonTouchUpInside() {
        
        let logInViewController = PFLogInViewController()
        
        presentViewController(logInViewController, animated: true, completion: nil)
    }
}
