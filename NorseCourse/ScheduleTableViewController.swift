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

    
    var savedSchedules: [[[String:String]]] {
        get { return information.savedSchedules! }
        set { information.savedSchedules = newValue }
    }

    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 0.92)
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if allschedules.count <= 1 && (schedules[0]["schedule"]!.count) == 0 {
            return "No Schedules"
        }
        return "Schedule #"+String(section+1)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if allschedules.count <= 1 {
            return 1
        }
        
        return schedules.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allschedules.count <= 1 && (schedules[0]["schedule"]!.count) == 0 {
            return 1
        }
        return max(schedules[section]["schedule"]!.count,1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ScheduleTableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleRow", forIndexPath: indexPath) as! ScheduleTableViewCell
        if allschedules.count > 0 && (schedules[0]["schedule"]!.count) != 0 {
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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

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
