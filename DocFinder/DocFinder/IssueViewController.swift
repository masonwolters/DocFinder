//
//  IssueViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

class IssueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Initialization
    
    init(issue: PFObject) {
        
        self.issue = issue
        
        super.init(nibName: "IssueViewController", bundle: nil)
        
        // Navigation item
        
        navigationItem.title = issue["phoneNumber"] as? String
        hidesBottomBarWhenPushed = true
        
        // Fetch
        
        fetchMessages()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Model
    
    let issue: PFObject
    
    var messages: [PFObject]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    func fetchMessages() {
        
        let query = PFQuery(className: "Message")
        query.whereKey("issue", equalTo: issue)
        query.orderByAscending("date")
        query.includeKey("doctor")
        
        query.findObjectsInBackgroundWithBlock { objects, error in
            if let objects = objects as? [PFObject] {
                self.messages = objects
            }
        }
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(Cell.DoctorMessage.nib, forCellReuseIdentifier: Cell.DoctorMessage.rawValue)
        tableView.registerNib(Cell.PatientMessage.nib, forCellReuseIdentifier: Cell.PatientMessage.rawValue)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 85.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: Table view
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Cell: String {
        
        case DoctorMessage = "DoctorMessageCell"
        case PatientMessage = "PatientMessageCell"
        
        var nib: UINib {
            return UINib(nibName: rawValue, bundle: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages![indexPath.row]
        
        let cell: MessageCell = {
            
            if let doctor = message["doctor"] as? PFObject {
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.DoctorMessage.rawValue, forIndexPath: indexPath) as MessageCell
                cell.senderLabel.text = doctor["name"] as? String
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.PatientMessage.rawValue, forIndexPath: indexPath) as MessageCell
                cell.senderLabel.text = "Patient"
                return cell
            }
        }()
        
        cell.dateLabel.text = MessageDateFormatter.localizedStringFromDate(message["date"] as NSDate)
        cell.messageLabel.text = message["text"] as? String
        
        return cell
    }
    
    // MARK: Keyboard
    
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint!
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        let localFrame = self.view.convertRect(frame, fromView: nil)
        
        bottomLayoutConstraint.constant = self.view.bounds.height - localFrame.minY
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0.0, options: nil, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
