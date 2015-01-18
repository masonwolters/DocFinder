//
//  IssueViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

protocol IssueViewControllerDelegate: class {
    
}

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
            scrollTableViewToBottom()
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
        
        updateTableViewBottomInset()
        updateSendButtonEnabled()
        keyboardMinY = view.bounds.height
        
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
    
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint!
    
    var keyboardMinY: CGFloat = 0.0
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        let localFrame = self.view.convertRect(frame, fromView: nil)
        keyboardMinY = localFrame.minY
        
        let distance = self.view.bounds.height - keyboardMinY
        
        bottomLayoutConstraint.constant = distance
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0.0, options: nil, animations: {
            self.view.layoutIfNeeded()
            self.bottomInset = distance + 44.0
            self.scrollTableViewToBottom()
        }, completion: nil)
    }
    
    // MARK: Bottom inset
    
    var bottomInset: CGFloat = 44.0 {
        didSet {
            updateTableViewBottomInset()
        }
    }
    
    func updateTableViewBottomInset() {
        tableView.contentInset.bottom = bottomInset
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func scrollTableViewToBottom() {
        tableView.contentOffset = CGPoint(x: 0.0, y: 44.0 + self.tableView.contentSize.height - keyboardMinY)
    }
    
    // MARK: Text field
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func textFieldEditingChanged() {
        updateSendButtonEnabled()
    }
    
    // MARK: Send button
    
    @IBOutlet var sendButton: UIButton!
    
    func updateSendButtonEnabled() {
        sendButton.enabled = !textField.text.isEmpty
    }
    
    @IBAction func sendButtonTouchUpInside() {
        
        let text = textField.text
        textField.text = ""
        
        updateSendButtonEnabled()
        
        let date = NSDate()
        
        let message = PFObject(className: "Message")
        message["date"] = date
        message["text"] = text
        message["issue"] = issue
        message["doctor"] = PFUser.currentUser()
        message.saveInBackgroundWithBlock { success, error in
            if success {
                
                self.messages! += [message]
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.issue["lastMessage"] = message
                    self.issue["date"] = date
                    self.issue.saveInBackgroundWithBlock({ success, error in })
                    
                    let textMessage = (PFUser.currentUser()["name"] as String) + ": " + text
                    
                    PFCloud.callFunctionInBackground("replyToIssue", withParameters: ["phoneNumber": self.issue["phoneNumber"], "message": textMessage]) { (result: AnyObject!, error: NSError!) in
                        
                    }
                }
            }
        }
    }
}
