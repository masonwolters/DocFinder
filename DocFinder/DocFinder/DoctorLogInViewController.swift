//
//  MainViewController.swift
//  
//
//  Created by Russell Ladd on 1/17/15.
//
//

import UIKit

class DoctorLogInViewController: UIViewController, PFLogInViewControllerDelegate, DoctorViewControllerDelegate {
    
    // MARK: Actions
    
    @IBAction func logInButtonTouchUpInside() {
        
        let logInViewController = PFLogInViewController()
        logInViewController.delegate = self
        
        presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    // MARK: PFLogInViewControllerDelegate
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        
        dismissViewControllerAnimated(true) {
            
            let doctor = Doctor(object: user)
            
            let doctorViewController = DoctorViewController(doctor: doctor!)
            doctorViewController.delegate = self
            
            self.showViewController(doctorViewController, sender: nil)
        }
    }
    
    // MARK: DoctorViewControllerDelegate
    
    func doctorViewControllerDidLogout(doctorViewController: DoctorViewController) {
        navigationController!.popToRootViewControllerAnimated(true)
    }
}
