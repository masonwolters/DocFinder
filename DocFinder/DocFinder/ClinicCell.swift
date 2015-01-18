//
//  ClinicCell.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

class ClinicCell: UITableViewCell {
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.activityIndicatorViewStyle = .Gray
    }
    
    var loading: Bool = false {
        didSet {
            accessoryView = loading ? activityIndicatorView : nil
            loading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        }
    }
}
