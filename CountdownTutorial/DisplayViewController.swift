//
//  DisplayViewController.swift
//  CountdownTutorial
//
//  Created by Chad Towle on 12/23/15.
//  Copyright © 2015 Intertech. All rights reserved.
//

import UIKit
import WatchConnectivity

class DisplayViewController: UIViewController, WCSessionDelegate {
    @IBOutlet weak var startDateLabel: UILabel!
    
    var savedDate: NSDate = NSDate()
    let userCalendar = NSCalendar.currentCalendar()
    var session : WCSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        
        // get values from user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let dateString = defaults.stringForKey("dateKey")
        {
            startDateLabel.text = dateString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSegue(segue:UIStoryboardSegue) {
        let dateFormat = NSDateFormatter()
        dateFormat.calendar = userCalendar
        dateFormat.dateFormat = "yyyy-MM-dd"
        let savedDateString = dateFormat.stringFromDate(savedDate)
        startDateLabel.text = savedDateString
        
        // save to user defaults for use here in phone app
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedDateString, forKey: "dateKey")
        
        // save values to session to be shared with watch
        let applicationDict = ["dateKey":savedDateString]
        do {
            try session.updateApplicationContext(applicationDict)
        } catch {
            print("Error updating application context.")
        }
        
        // update complication
        if session.watchAppInstalled {
            session.transferCurrentComplicationUserInfo(applicationDict)
        }
    }
}
