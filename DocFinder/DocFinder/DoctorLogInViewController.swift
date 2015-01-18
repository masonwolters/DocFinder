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
        
        let installation = PFInstallation.currentInstallation()
        installation["doctor"] = user
        installation.saveEventually()
        
        dismissViewControllerAnimated(true) {
            self.showDoctorViewController(user, animated: true)
        }
    }
    
    // MARK: DoctorViewController
    
    func showDoctorViewController(doctor: PFUser, animated: Bool) {
        
        let doctorViewController = DoctorViewController(doctor: doctor)
        doctorViewController.delegate = self
        
        navigationController!.pushViewController(doctorViewController, animated: animated)
    }
    
    func doctorViewControllerDidLogout(doctorViewController: DoctorViewController) {
        navigationController!.popToRootViewControllerAnimated(true)
    }
}
