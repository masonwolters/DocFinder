//
//  Doctor.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import Foundation

struct Doctor {
    
    let ID: String
    let username: String
    let name: String
    let specialty: String
    // Clinic
}

extension Doctor: Fetchable {
    
    init?(object: PFObject) {
        
        let user = object as PFUser
        
        let name = user["name"] as? String
        let specialty = user["specialty"] as? String
        
        if name == nil || specialty == nil {
            return nil
        }
        
        self.ID = user.objectId
        self.username = user.username
        self.name = name!
        self.specialty = specialty!
    }
}
