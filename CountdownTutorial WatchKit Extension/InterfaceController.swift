//
//  InterfaceController.swift
//  CountdownTutorial WatchKit Extension
//
//  Created by Chad Towle on 12/23/15.
//  Copyright © 2015 Intertech. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var yearsLabel: WKInterfaceLabel!
    @IBOutlet var monthsLabel: WKInterfaceLabel!
    @IBOutlet var daysLabel: WKInterfaceLabel!
    
    var session : WCSession!
    
    override init() {
        super.init()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        // get values from app context
        let displayDate = (applicationContext["dateKey"] as? String)
        
        // save to user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(displayDate, forKey: "dateKey")
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        if let dateString = userInfo["dateKey"] as? String {
            
            // save new value to user defaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(dateString, forKey: "dateKey")
            
            // reload complication data
            reloadComplications()
        }
    }

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
        
        // get values from user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        var startDateIntertech = NSDate()
        if let dateString = defaults.stringForKey("dateKey")
        {
            startDateIntertech = dateFormatter.dateFromString(dateString)!
        }
        
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
    
    func reloadComplications() {
        let server = CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications where complications.count > 0 else {
            return
        }
        
        for complication in complications  {
            server.reloadTimelineForComplication(complication)
        }
    }
}
