//
//  MainViewController.swift
//  
//
//  Created by Russell Ladd on 1/17/15.
//
//

import UIKit
import CoreGraphics

class DoctorLogInViewController: UIViewController, UITextFieldDelegate, DoctorViewControllerDelegate {
    
    // MARK: Initialization
    
    override init() {
        
        super.init(nibName: "DoctorLogInViewController", bundle: nil)
        
        navigationItem.title = "FindMD"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20.0
        imageView.layer.minificationFilter = kCAFilterTrilinear
        imageView.clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: Log in button
    
    @IBOutlet var logInButton: UIButton!
    
    @IBAction func logInButtonTouchUpInside() {
        
        PFUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text) { user, error in
            
            if let doctor = user {
                
                self.passwordTextField.text = ""
                
                self.showDoctorViewController(doctor, animated: true)
                
            } else {
                
                let alertController = UIAlertController(title: "Invalid Credentials", message: "We could not find an account matching that email and password.", preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Image view
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Text fields
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func textFieldEditingChanged() {
        logInButton.enabled = !emailTextField.text.isEmpty && !passwordTextField.text.isEmpty
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if logInButton.enabled {
            logInButtonTouchUpInside()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    // MARK: Keyboard
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint!
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        let localFrame = containerView.convertRect(frame, fromView: nil)
        let keyboardMinY = localFrame.minY
        
        let distance = containerView.bounds.height - keyboardMinY
        
        bottomLayoutConstraint.constant = max(distance, 0.0)
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0.0, options: nil, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: Tap gesture recognizer
    
    @IBAction func tapGestureRecognizerAction() {
        view.endEditing(true)
    }
    
    // MARK: PFLogInViewControllerDelegate
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        
        let installation = PFInstallation.currentInstallation()
        installation["doctor"] = user
        installation.saveEventually()
        
        dismissViewControllerAnimated(true, completion: nil)
        
        showDoctorViewController(user, animated: false)
    }
    
    // MARK: DoctorViewController
    
    weak var doctorViewController: DoctorViewController?
    
    func showDoctorViewController(doctor: PFUser, animated: Bool) {
        
        let doctorViewController = DoctorViewController(doctor: doctor)
        doctorViewController.delegate = self
        
        navigationController!.pushViewController(doctorViewController, animated: animated)
        
        self.doctorViewController = doctorViewController
    }
    
    func doctorViewControllerDidLogout(doctorViewController: DoctorViewController) {
        navigationController!.popToRootViewControllerAnimated(true)
    }
}
