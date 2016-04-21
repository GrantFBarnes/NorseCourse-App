//
//  ScheduleTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    var schedules = [[String:AnyObject]]()
    
    var numSections: Int?
    
    var startidx: String? {
        didSet {
            loadMore()
        }
    }
    
    var allschedules = [[[String:AnyObject]]]() {
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    
    
    private func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        tableView.reloadData()
        sender?.endRefreshing()
    }
    

    @IBAction func register(sender: UIButton) {
        let url = NSURL(string: "my.luther.edu")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    private func getSelectedSchedule(indexPath: NSIndexPath) -> [[String:String]] {
        
        var returnSchedule = [[String:String]]()
        let s = allschedules[indexPath.section]
        for course in 0..<s.count {
            let sect = s[course]
            var temp = [String:String]()
            temp["num"] = sect["name"]! as? String
            temp["name"] = sect["shortTitle"]! as? String
            
            var meetingText = ""
            var check = true
            for i in 0..<sect["sectionMeetings"]!.count {
                if i == sect["sectionMeetings"]!.count-1 && i != 0 {
                    meetingText += ", and"
                } else if i > 0 {
                    meetingText += ", "
                }
                if String(sect["sectionMeetings"]![i]["days"]!!) == "nan" {
                    check = false
                }
                meetingText += String(sect["sectionMeetings"]![i]["days"]!!) + " "
                meetingText += String(sect["sectionMeetings"]![i]["startTime"]!!) + "-"
                meetingText += String(sect["sectionMeetings"]![i]["endTime"]!!) + " in "
                meetingText += String(sect["sectionMeetings"]![i]["room"]!![i]["buildingName"]!!)
                meetingText += " " + String(sect["sectionMeetings"]![i]["room"]!![i]["number"]!!)
                
            }
            
            if check {
                temp["meetingTime"] = meetingText
            } else {
                temp["meetingTime"] = "* No times for this course *"
            }
            
            
            var professorText = "Taught by: "
            check = true
            for i in 0..<sect["faculty"]!.count {
                if i == sect["faculty"]!.count-1 && i != 0 {
                    professorText += ", and"
                } else if i > 0 {
                    professorText += ", "
                }
                if String(sect["faculty"]![i]["name"]!!) == "nan. nan" {
                    check = false
                }
                professorText += String(sect["faculty"]![i]["name"]!!)
                
            }
            
            if check {
                temp["professor"] = professorText
            } else {
                temp["professor"] = "* No professor listed *"
            }
                
                
            returnSchedule.append(temp)
        }
        
        return returnSchedule
    }
    
    private func getAllSchedules() {
        
        dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)) {
            
            var big_temp = [[[String:AnyObject]]]()
            for schedule in 0..<self.schedules.count {
                var temp = [[String:AnyObject]]()
                for sect in 0..<self.schedules[schedule]["schedule"]!.count {
                    
                    let addon = (self.schedules[schedule]["schedule"]!) as! [Int]
                    let url = "https://norsecourse.com:5000/api/sections/" + String(addon[sect])
                    
                    let scheduleURL: NSURL = NSURL(string: url)!
                    let data = NSData(contentsOfURL: scheduleURL)!
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        
                        if let dict = json as? [String:AnyObject] {
                            temp.append(dict)
                        }
                        
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                }
                big_temp.append(temp)
            }
            self.allschedules += big_temp
        }
    }
    
    
    private func getSchedules(startidx: String) {
        dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)) {
            var url = "https://norsecourse.com:5000/api/schedules?index="+startidx

            if self.preferredCourses.count > 0 {
                url += "&"
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
                url += "&"
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
                url += "&"
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
                url += "&"
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
                url += "&"
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
                url += "&"
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
                self.schedules += temp
            }
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var requiredCourses: [[String:AnyObject]] {
        get { return defaults.objectForKey("reqCourses") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqCourses") }
    }
    
    var preferredCourses: [[String:AnyObject]] {
        get { return defaults.objectForKey("prefCourses") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefCourses") }
    }
    
    var requiredSections: [[String:AnyObject]] {
        get { return defaults.objectForKey("reqSections") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqSections") }
    }
    
    var preferredSections: [[String:AnyObject]] {
        get { return defaults.objectForKey("prefSections") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefSections") }
    }
    
    var requiredGenEds: [String] {
        get { return defaults.objectForKey("reqGenEds") as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqGenEds") }
    }
    
    var preferredGenEds: [String] {
        get { return defaults.objectForKey("prefGenEds") as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefGenEds") }
    }
    
    var savedSchedules: [[[String:String]]] {
        get { return defaults.objectForKey("savedSchedules") as? [[[String:String]]] ?? [] }
        set { defaults.setObject(newValue, forKey: "savedSchedules") }
    }
    
    private func loadMore() {
        dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)) {
            self.getSchedules(self.startidx!)
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 0.92)
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if allschedules.count <= 1 {
            return "No Schedules"
        }
        if numSections == section {
            return "More Schedules"
        }
        return "Schedule #"+String(section+1)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if allschedules.count <= 1 {
            return 1
        }
        if schedules.count%20 == 0 {
            return schedules.count + 1
        } else {
            return schedules.count
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allschedules.count <= 1 {
            return 1
        }
        if numSections == section {
            return 1
        }
        return max(schedules[section]["schedule"]!.count,1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ScheduleTableViewCell {
        
        // Configure the cell...
        if numSections != indexPath.section {
            let cell = tableView.dequeueReusableCellWithIdentifier("scheduleRow", forIndexPath: indexPath) as! ScheduleTableViewCell
            if allschedules.count > 1 {
                cell.section = allschedules[indexPath.section][indexPath.row]
                cell.error = schedules[indexPath.section]["error"]! as? String ?? "no error returned"
                return cell
            } else {
                let alertController = UIAlertController(title: "Error", message:
                    schedules[indexPath.section]["error"]! as? String, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                cell.error = schedules[indexPath.section]["error"]! as? String ?? "no error returned"
                return cell
            }
        
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("loadRow", forIndexPath: indexPath) as! ScheduleTableViewCell
            cell.load = true
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == numSections {
            if schedules.count - Int(numSections!) > 1 {
                numSections = schedules.count
                startidx = String(schedules[schedules.count-1]["index"]!)
                self.tableView.reloadData()
                self.refresh()
            }
        } else {
            let optionMenu = UIAlertController(title: nil, message: "Save Schedule?", preferredStyle: .ActionSheet)
            
            
            let saveAction = UIAlertAction(title: "Add to Saved Schedules", style: .Default, handler:{
                (alert: UIAlertAction!) -> Void in
                
                let save = self.getSelectedSchedule(indexPath)
                self.savedSchedules.append(save)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
}
