//
//  DoctorInfoViewController.swift
//  DocFinder
//
//  Created by Mason Wolters on 1/18/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

class DoctorInfoViewController: UIViewController {
    
    //MARK: Initialization
    
    init(doctor: PFUser) {
        
        self.doctor = doctor
        
        super.init(nibName: "DoctorInfoViewController", bundle: nil)
        
        navigationItem.title = "My Info"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Model
    
    let doctor: PFUser
    
    let editableFields = ["name", "specialty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
