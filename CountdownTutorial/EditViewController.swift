//
//  EditViewController.swift
//  CountdownTutorial
//
//  Created by Chad Towle on 12/23/15.
//  Copyright © 2015 Intertech. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var startDatePicker: UIDatePicker!

    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let dateString = defaults.stringForKey("dateKey")
        {
            let userCalendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.calendar = userCalendar
            dateFormat.dateFormat = "yyyy-MM-dd"
            startDatePicker.date = dateFormat.dateFromString(dateString)!
        }
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send values to display view controller
        if let destination = segue.destinationViewController as? DisplayViewController {
            destination.savedDate = startDatePicker.date
        }
    }
}
