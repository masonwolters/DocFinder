//
//  MessageDateFormatter.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import Foundation

struct MessageDateFormatter {
    
    static private let todayDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        return formatter;
    }()
    
    static private let otherDayDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.doesRelativeDateFormatting = true;
        return formatter;
    }()
    
    static func localizedStringFromDate(date: NSDate) -> String {
        let formatter = NSCalendar.currentCalendar().isDateInToday(date) ? MessageDateFormatter.todayDateFormatter : MessageDateFormatter.otherDayDateFormatter
        return formatter.stringFromDate(date)
    }
}
