//
//  InterfaceController.swift
//  CountdownTutorial WatchKit Extension
//
//  Created by Chad Towle on 12/23/15.
//  Copyright © 2015 Intertech. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var yearsLabel: WKInterfaceLabel!
    @IBOutlet var monthsLabel: WKInterfaceLabel!
    @IBOutlet var daysLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // start/refresh countdown using a one-second timer
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
            selector: Selector("startCountDown:"), userInfo: nil, repeats: true)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func startCountDown(timer: NSTimer) {
        // create calendar, date and formatter variables
        let userCalendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.calendar = userCalendar
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // create variable to hold 7 years
        let sevenYears: NSDateComponents = NSDateComponents()
        sevenYears.setValue(7, forComponent: NSCalendarUnit.Year);
        
        // hard-code start date value for part one of this tutorial
        let startDateIntertech: NSDate = dateFormatter.dateFromString("2005-06-01")!
        
        // add 7 years to our start date to calculate the date of our sabbatical
        var sabbaticalDate = userCalendar.dateByAddingComponents(sevenYears, toDate: startDateIntertech,
            options: NSCalendarOptions(rawValue: 0))
        
        // since we get a sabbatical every 7 years, add 7 years until sabbaticalDate is in the future
        while sabbaticalDate!.timeIntervalSinceNow.isSignMinus {
            sabbaticalDate = userCalendar.dateByAddingComponents(sevenYears, toDate: sabbaticalDate!,
                options: NSCalendarOptions(rawValue: 0))
        }
        
        // create year, month and day values for display
        let flags: NSCalendarUnit = [.Year, .Month, .Day]
        let dateComponents = userCalendar.components(flags, fromDate: NSDate(), toDate: sabbaticalDate!, options: [])
        let year = dateComponents.year
        let month = dateComponents.month
        let day = dateComponents.day
        
        // set labels on interface
        yearsLabel.setText(String(format: "%d Years", year))
        monthsLabel.setText(String(format: "%d Months", month))
        daysLabel.setText(String(format: "%d Days", day))
    }
}
