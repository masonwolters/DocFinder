//
//  EditAttributeCell.swift
//  DocFinder
//
//  Created by Mason Wolters on 1/18/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

protocol EditAttributeDelegate: class {
    
    func changedAttribute(attribute: String, value: String)
}

class EditAttributeCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var attributeLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.addTarget(self, action: "valueChanged", forControlEvents: UIControlEvents.EditingDidEnd)
        textField.delegate = self
        textField.textColor = tintColor
    }
    
    override func tintColorDidChange() {
        textField.textColor = tintColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Delegate
    
    var attribute: String? {
        didSet {
            attributeLabel.text = attribute?.capitalizedString
        }
    }
    weak var delegate: EditAttributeDelegate?
    
    func valueChanged() {
        if let del = delegate {
            del.changedAttribute(attribute!, value: textField.text)
        }
    }
    
    //MARK: TextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
