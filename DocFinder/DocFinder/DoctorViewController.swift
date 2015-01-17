//
//  DoctorViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

protocol DoctorViewControllerDelegate: class {
    
    func doctorViewControllerDidLogout(doctorViewController: DoctorViewController)
}

class DoctorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Initialization
    
    init(doctor: Doctor) {
        super.init(nibName: "DoctorViewController", bundle: nil)
        
        self.doctor = doctor
    }
    
    // MARK: Delegate
    
    var delegate: DoctorViewControllerDelegate?
    
    // MARK: Model
    
    let doctor: Doctor
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(Cell.Clinic.nib, forCellReuseIdentifier: Cell.Clinic.rawValue)
        tableView.registerNib(Cell.Issue.nib, forCellReuseIdentifier: Cell.Issue.rawValue)
        tableView.registerNib(Cell.Loading.nib, forCellReuseIdentifier: Cell.Loading.rawValue)
    }
    
    // MARK: Logout
    
    func logoutBarButtonItemAction() {
        
        delegate?.doctorViewControllerDidLogout(self)
    }
    
    // MARK: Table view
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Section: Int {
        case Clinic
        case Issues
    }
    
    enum Cell: String {
        
        case Clinic = "ClinicCell"
        case Issue = "IssueCell"
        case Loading = "LoadingCell"
        
        var nib: UINib {
            return UINib(nibName: rawValue, bundle: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section)! {
            
        case .Clinic:
            return 1
            
        case .Issues:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section)! {
            
        case .Clinic:
            return tableView.dequeueReusableCellWithIdentifier(Cell.Clinic.rawValue, forIndexPath: indexPath) as UITableViewCell
            
        case .Issues:
            return tableView.dequeueReusableCellWithIdentifier(Cell.Loading.rawValue, forIndexPath: indexPath) as UITableViewCell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch Section(rawValue: section)! {
            
        case .Clinic:
            return "Clinic"
            
        case .Issues:
            return "Issues"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
}
