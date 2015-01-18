//
//  DoctorInfoViewController.swift
//  DocFinder
//
//  Created by Mason Wolters on 1/18/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

class DoctorInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditAttributeDelegate {
    
    //MARK: Initialization
    
    init(doctor: PFUser) {
        
        self.doctor = doctor
        
        super.init(nibName: "DoctorInfoViewController", bundle: nil)
        
        navigationItem.title = "My Info"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: Model
    
    let doctor: PFUser
    
    let editableFields = ["name", "specialty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "EditAttributeCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK: TableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableFields.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as EditAttributeCell
        cell.attribute = editableFields[indexPath.row]
        cell.textField.text = doctor[editableFields[indexPath.row]] as String
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as EditAttributeCell
        cell.textField.becomeFirstResponder()
        
    }
    
    func changedAttribute(attribute: String, value: String) {
        doctor[attribute] = value
        doctor.saveEventually()
    }
    
    
}
