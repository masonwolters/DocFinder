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

class DoctorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DoctorInfoViewControllerDelegate, ClinicViewControllerDelegate, IssueViewControllerDelegate {
    
    // MARK: Initialization
    
    init(doctor: PFUser) {
        
        self.doctor = doctor
        
        super.init(nibName: "DoctorViewController", bundle: nil)
        
        // Navigation item
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutBarButtonItemAction")
        navigationItem.title = "Me"
        
        // Fetch
        
        fetchIssues()
        fetchClinic()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Delegate
    
    weak var delegate: DoctorViewControllerDelegate?
    
    // MARK: Model
    
    let doctor: PFUser
    
    var clinic: PFObject? {
        didSet {
            tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: Section.MeRow.Clinic.rawValue, inSection: Section.Me.rawValue)], withRowAnimation: .Fade)
        }
    }
    
    func fetchClinic() {
        
        let clinic = doctor["clinic"] as PFObject
        
        clinic.fetchIfNeededInBackgroundWithBlock { clinic, error in
            if let clinic = clinic {
                self.clinic = clinic
            }
        }
    }
    
    var issues: [PFObject]? {
        didSet {
            tableView.reloadSections(NSIndexSet(index: Section.Issues.rawValue), withRowAnimation: .Fade)
        }
    }
    
    func fetchIssues() {
        
        let query = PFQuery(className: "Issue")
        query.whereKey("clinic", equalTo: doctor["clinic"])
        query.whereKey("closed", notEqualTo: true)
        query.orderByDescending("date")
        query.includeKey("lastMessage")
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchIssues", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            
            transitionCoordinator()?.animateAlongsideTransition({ context in
                
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                
                }, completion: { context in
                    
                    if context.isCancelled() {
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                    }
            })
        }
    }
    
    // MARK: Logout
    
    func logoutBarButtonItemAction() {
        
        PFUser.logOut()
        
        PFInstallation.currentInstallation().removeObjectForKey("doctor")
        PFInstallation.currentInstallation().saveEventually()
        
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
                cell.textLabel!.text = doctor["name"] as? String
                cell.detailTextLabel!.text = doctor["specialty"] as? String
                return cell
                
            case .Clinic:
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.Clinic.rawValue, forIndexPath: indexPath) as ClinicCell
                cell.loading = clinic == nil
                cell.detailTextLabel!.text = clinic?["name"] as? String ?? ""
                cell.setNeedsLayout()
                return cell
            }
            
        case .Issues:
            
            if let issues = issues {
                
                let issue = issues[indexPath.row]
                let message = issue["lastMessage"] as? PFObject
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.Issue.rawValue, forIndexPath: indexPath) as IssueCell
                cell.patientNumberLabel.text = issue["phoneNumber"] as? String
                cell.dateLabel.text = MessageDateFormatter.localizedStringFromDate(issue["date"] as NSDate)
                cell.messageLabel.text = (message?["text"] as? String) ?? ""
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch Section(rawValue: indexPath.section)! {
            
        case .Me:
            return 44.0
            
        case .Issues:
            return 78.0
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        switch Section(rawValue: indexPath.section)! {
            
        case .Me:
            
            switch Section.MeRow(rawValue: indexPath.row)! {
            case .Doctor:
                return true
                
            case .Clinic:
                return clinic != nil
            }
            
        case .Issues:
            return issues != nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch Section(rawValue: indexPath.section)! {
            
        case .Me:
            
            switch Section.MeRow(rawValue: indexPath.row)! {
            case .Doctor:
                showDoctorInfoViewController()
                
            case .Clinic:
                showClinicViewController(clinic!, animated: true)
            }
            
        case .Issues:
            showIssueViewController(issues![indexPath.row], animated: true)
        }
    }
    
    // MARK: ClinicViewController
    
    func showClinicViewController(clinic: PFObject, animated: Bool) {
        
        let clinicViewController = ClinicViewController(clinic: clinic)
        clinicViewController.delegate = self
        
        navigationController!.pushViewController(clinicViewController, animated: animated)
    }
    
    func clinicViewControllerDidChangeClinicName(clinicViewController: ClinicViewController) {
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: Section.MeRow.Clinic.rawValue, inSection: Section.Me.rawValue)], withRowAnimation: .None)
    }
    
    // MARK: IssueViewController
    
    weak var issueViewController: IssueViewController?
    
    func showIssueViewController(issue: PFObject, animated: Bool) {
        
        func pushIssueViewController() {
            
            let issueViewController = IssueViewController(issue: issue)
            issueViewController.delegate = self
            
            navigationController!.pushViewController(issueViewController, animated: animated)
            
            self.issueViewController = issueViewController
        }
        
        if let issueViewController = issueViewController {
            
            if issueViewController.issue.objectId != issue.objectId {
                
                navigationController!.popToViewController(self, animated: false)
                pushIssueViewController()
            }
            
        } else {
            
            pushIssueViewController()
        }
    }
    
    func issueViewControllerDidSendMessage(issueViewController: IssueViewController) {
        
        tableView.reloadSections(NSIndexSet(index: Section.Issues.rawValue), withRowAnimation: .None)
    }
    
    // MARK: InfoViewController
    
    func showDoctorInfoViewController() {
        
        let doctorInfoViewController = DoctorInfoViewController(doctor: PFUser.currentUser())
        doctorInfoViewController.delegate = self
        
        navigationController!.pushViewController(doctorInfoViewController, animated: true)
    }
    
    func doctorInfoViewControllerDidChangeAttribute(doctorInfoViewController: DoctorInfoViewController) {
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: Section.MeRow.Doctor.rawValue, inSection: Section.Me.rawValue)], withRowAnimation: .None)
    }

}
