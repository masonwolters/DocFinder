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
    
    init(doctor: PFUser) {
        
        self.doctor = doctor
        
        super.init(nibName: "DoctorViewController", bundle: nil)
        
        // Navigation item
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutBarButtonItemAction")
        navigationItem.title = "Me"
        
        // Fetch
        
        fetchIssues()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Delegate
    
    var delegate: DoctorViewControllerDelegate?
    
    // MARK: Model
    
    let doctor: PFUser
    
    var issues: [PFObject]? {
        didSet {
            tableView.reloadSections(NSIndexSet(index: Section.Issues.rawValue), withRowAnimation: .Fade)
        }
    }
    
    func fetchIssues() {
        
        let query = PFQuery(className: "Issue")
        query.whereKey("doctor", equalTo: doctor)
        query.orderByAscending("date")
        
        query.findObjectsInBackgroundWithBlock { objects, error in
            if let objects = objects as? [PFObject] {
                self.issues = objects
            }
        }
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(Cell.Doctor.nib, forCellReuseIdentifier: Cell.Doctor.rawValue)
        tableView.registerNib(Cell.Clinic.nib, forCellReuseIdentifier: Cell.Clinic.rawValue)
        tableView.registerNib(Cell.Issue.nib, forCellReuseIdentifier: Cell.Issue.rawValue)
        tableView.registerNib(Cell.Loading.nib, forCellReuseIdentifier: Cell.Loading.rawValue)
    }
    
    // MARK: Logout
    
    func logoutBarButtonItemAction() {
        
        PFUser.logOut()
        
        delegate?.doctorViewControllerDidLogout(self)
    }
    
    // MARK: Table view
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Section: Int {
        
        case Me
        case Issues
        
        enum MeRow: Int {
            case Doctor
            case Clinic
        }
    }
    
    enum Cell: String {
        
        case Doctor = "DoctorCell"
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
            
        case .Me:
            return 2
            
        case .Issues:
            return issues?.count ?? 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section)! {
            
        case .Me:
            
            switch Section.MeRow(rawValue: indexPath.row)! {
            case .Doctor:
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.Doctor.rawValue, forIndexPath: indexPath) as UITableViewCell
                cell.textLabel!.text! = doctor["name"] as String
                cell.detailTextLabel!.text! = doctor["specialty"] as String
                return cell
                
            case .Clinic:
                return tableView.dequeueReusableCellWithIdentifier(Cell.Clinic.rawValue, forIndexPath: indexPath) as UITableViewCell
            }
            
        case .Issues:
            
            if let issues = issues {
                
                let issue = issues[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.Issue.rawValue, forIndexPath: indexPath) as IssueCell
                cell.patientNumberLabel.text! = issue["patientNumber"] as String
                return cell
                
            } else {
                
                return tableView.dequeueReusableCellWithIdentifier(Cell.Loading.rawValue, forIndexPath: indexPath) as UITableViewCell
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch Section(rawValue: section)! {
            
        case .Me:
            return "My Info"
            
        case .Issues:
            return "Issues"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
}
