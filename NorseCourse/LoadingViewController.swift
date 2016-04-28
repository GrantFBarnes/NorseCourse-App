//
//  LoadingViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        getSchedules()
        spinner.startAnimating()
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var schedules = [[String:AnyObject]]() {
        didSet {
            getAllSchedules()
        }
    }
    
    var allGenEds = [String:Int]()
    
    var allschedules = [[[String:AnyObject]]]() {
        didSet {
            spinner.stopAnimating()
            spinner.hidden = true
            messageLabel.text = "Go Back to edit schedule your criteria"
            performSegueWithIdentifier("showSchedules", sender: 0)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSchedules":
                let svc = segue.destinationViewController as! ScheduleTableViewController
                svc.schedules = schedules
                svc.allschedules = allschedules
            default: break
            }
        }
    }
    
    private func getAllSchedules() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            var big_temp = [[[String:AnyObject]]]()
            for schedule in 0..<self.schedules.count {
                var temp = [[String:AnyObject]]()
                for sect in 0..<self.schedules[schedule]["schedule"]!.count {
                    
                    let addon = (self.schedules[schedule]["schedule"]!) as! [Int]
                    let url = "https://norsecourse.com:5000/api/sections/" + String(addon[sect])
                    
                    let scheduleURL: NSURL = NSURL(string: url)!
                    if let data = NSData(contentsOfURL: scheduleURL) {
                    
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? [String:AnyObject] {
                                temp.append(dict)
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                big_temp.append(temp)
            }
            self.allschedules = big_temp
        })
    }
    
    
    private func getSchedules() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var url = "https://norsecourse.com:5000/api/schedules?"
            
            var multiple = false
            
            if self.preferredCourses.count > 0 {
                multiple = true
                url += "preferredCourses="
                var count = 0
                for course in self.preferredCourses {
                    count += 1
                    if count > 1 {
                        url += "%2C" + String(course["courseId"]!)
                    } else {
                        url += String(course["courseId"]!)
                    }
                }
            }
            
            if self.requiredCourses.count > 0 {
                if multiple {
                    url += "&"
                }
                multiple = true
                url += "requiredCourses="
                var count = 0
                for course in self.requiredCourses {
                    count += 1
                    if count > 1 {
                        url += "%2C" + String(course["courseId"]!)
                    } else {
                        url += String(course["courseId"]!)
                    }
                }
            }
            
            if self.preferredSections.count > 0 {
                if multiple {
                    url += "&"
                }
                multiple = true
                url += "preferredSections="
                var count = 0
                for course in self.preferredSections {
                    count += 1
                    if count > 1 {
                        url += "%2C" + String(course["id"]!)
                    } else {
                        url += String(course["id"]!)
                    }
                }
            }
            
            if self.requiredSections.count > 0 {
                if multiple {
                    url += "&"
                }
                multiple = true
                url += "requiredSections="
                var count = 0
                for course in self.requiredSections {
                    count += 1
                    if count > 1 {
                        url += "%2C" + String(course["id"]!)
                    } else {
                        url += String(course["id"]!)
                    }
                }
            }
            
            if self.requiredGenEds.count > 0 {
                if multiple {
                    url += "&"
                }
                multiple = true
                url += "requiredGenEds="
                var count = 0
                for course in self.requiredGenEds {
                    count += 1
                    if count > 1 {
                        url += "%2C" + course.characters.split{$0 == " "}.map(String.init)[0]
                    } else {
                        url += course.characters.split{$0 == " "}.map(String.init)[0]
                    }
                }
            }
            
            if self.preferredGenEds.count > 0 {
                if multiple {
                    url += "&"
                }
                multiple = true
                url += "preferredGenEds="
                var count = 0
                for course in self.preferredGenEds {
                    count += 1
                    if count > 1 {
                        url += "%2C" + course.characters.split{$0 == " "}.map(String.init)[0]
                    } else {
                        url += course.characters.split{$0 == " "}.map(String.init)[0]
                    }
                }
            }
            
            let scheduleURL: NSURL = NSURL(string: url)!
            print(scheduleURL)
            if let data = NSData(contentsOfURL: scheduleURL) {
            
                var temp = [[String:AnyObject]]()
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    
                    if let dict = json as? Array<[String:AnyObject]> {
                        for schedule in dict {
                            temp.append(schedule)
                        }
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
                self.schedules = temp
            } else {
                let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                self.spinner.stopAnimating()
                self.spinner.hidden = true
                self.messageLabel.text = "Fix your network problem before trying this again"
            }
        })
    }
    
//    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var requiredCourses: [[String:AnyObject]] {
        get { return information.requiredCourses! }
        set { information.requiredCourses = newValue }
    }
    
    var preferredCourses: [[String:AnyObject]] {
        get { return information.preferredCourses! }
        set { information.preferredCourses = newValue }
    }
    
    var requiredSections: [[String:AnyObject]] {
        get { return information.requiredSections! }
        set { information.requiredSections = newValue }
    }
    
    var preferredSections: [[String:AnyObject]] {
        get { return information.preferredSections! }
        set { information.preferredSections = newValue }
    }
    
    var requiredGenEds: [String] {
        get { return information.requiredGenEds! }
        set { information.requiredGenEds = newValue }
    }
    
    var preferredGenEds: [String] {
        get { return information.preferredGenEds! }
        set { information.preferredGenEds = newValue }
    }
}
