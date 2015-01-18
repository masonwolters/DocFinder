//
//  EditAttributeCell.swift
//  DocFinder
//
//  Created by Mason Wolters on 1/18/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

class EditAttributeCell: UITableViewCell {

    @IBOutlet var attributeLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
