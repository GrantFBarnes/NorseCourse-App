//
//  PlanTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class PlanTableViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

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
        self.tableView.reloadData()
        refresh()
    }
    
    
    @IBAction func clearDefaults(sender: UIButton) {
        requiredCourses = []
        preferredCourses = []
        requiredSections = []
        preferredSections = []
        requiredGenEds = []
        preferredGenEds = []
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        tableView.reloadData()
        sender?.endRefreshing()
    }
    
    var requiredCourses: [[String:AnyObject]] {
        get { return information.requiredCourses! }
        set {
            information.requiredCourses = newValue
            tableView.reloadData()
        }
    }
    
    var preferredCourses: [[String:AnyObject]] {
        get { return information.preferredCourses! }
        set {
            information.preferredCourses = newValue
            tableView.reloadData()
        }
    }
    
    var requiredSections: [[String:AnyObject]] {
        get { return information.requiredSections! }
        set {
            information.requiredSections = newValue
            tableView.reloadData()
        }
    }
    
    var preferredSections: [[String:AnyObject]] {
        get { return information.preferredSections! }
        set {
            information.preferredSections = newValue
            tableView.reloadData()
        }
    }
    
    var requiredGenEds: [String] {
        get { return information.requiredGenEds! }
        set {
            information.requiredGenEds = newValue
            tableView.reloadData()
        }
    }
    
    var preferredGenEds: [String] {
        get { return information.preferredGenEds! }
        set {
            information.preferredGenEds = newValue
            tableView.reloadData()
        }
    }

    var sections = [0:"Required Courses",1:"Required Sections",2:"Preferred Courses",3:"Preferred Sections",4:"Required Gen Eds",5:"Preferred GenEds"]

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 0.92)
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if requiredCourses.count > 0 {
                return requiredCourses.count
            } else {
                return 1
            }
        }
        if section == 1 {
            if requiredSections.count > 0 {
                return requiredSections.count
            } else {
                return 1
            }
        }
        if section == 2 {
            if preferredCourses.count > 0 {
                return preferredCourses.count
            } else {
                return 1
            }
        }
        if section == 3 {
            if preferredSections.count > 0 {
                return preferredSections.count
            } else {
                return 1
            }
        }
        if section == 4 {
            if requiredGenEds.count > 0 {
                return requiredGenEds.count
            } else {
                return 1
            }
        }
        if section == 5 {
            if preferredGenEds.count > 0 {
                return preferredGenEds.count
            } else {
                return 1
            }
        }
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! PlanTableViewCell
            
            cell.section = "Required Courses"
            cell.index = indexPath
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath) as! PlanTableViewCell
            
            cell.section = "Required Sections"
            cell.index = indexPath
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! PlanTableViewCell
            
            cell.section = "Preferred Courses"
            cell.index = indexPath
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath) as! PlanTableViewCell
            
            cell.section = "Preferred Sections"
            cell.index = indexPath
            return cell
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GenEdCell", forIndexPath: indexPath) as! PlanTableViewCell
            
            cell.section = "Required Gen Eds"
            cell.index = indexPath
            return cell
        }
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GenEdCell", forIndexPath: indexPath) as! PlanTableViewCell
            
            cell.section = "Preferred Gen Eds"
            cell.index = indexPath
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GenEdCell", forIndexPath: indexPath) as! PlanTableViewCell
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            if indexPath.row < requiredCourses.count {
                return true
            } else {
                return false
            }
        }
        if indexPath.section == 1 {
            if indexPath.row < requiredSections.count {
                return true
            } else {
                return false
            }
        }
        if indexPath.section == 2 {
            if indexPath.row < preferredCourses.count {
                return true
            } else {
                return false
            }
        }
        if indexPath.section == 3 {
            if indexPath.row < preferredSections.count {
                return true
            } else {
                return false
            }
        }
        if indexPath.section == 4 {
            if indexPath.row < requiredGenEds.count {
                return true
            } else {
                return false
            }
        }
        if indexPath.section == 5 {
            if indexPath.row < preferredGenEds.count {
                return true
            } else {
                return false
            }
        }
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if indexPath.section == 0 {
                if indexPath.row < requiredCourses.count {
                    requiredCourses.removeAtIndex(indexPath.row)
                }
            }
            if indexPath.section == 1 {
                if indexPath.row < requiredSections.count {
                    requiredSections.removeAtIndex(indexPath.row)
                }
            }
            if indexPath.section == 2 {
                if indexPath.row < preferredCourses.count {
                    preferredCourses.removeAtIndex(indexPath.row)
                }
            }
            if indexPath.section == 3 {
                if indexPath.row < preferredSections.count {
                    preferredSections.removeAtIndex(indexPath.row)
                }
            }
            if indexPath.section == 4 {
                if indexPath.row < requiredGenEds.count {
                    requiredGenEds.removeAtIndex(indexPath.row)
                }
            }
            if indexPath.section == 5 {
                if indexPath.row < preferredGenEds.count {
                    preferredGenEds.removeAtIndex(indexPath.row)
                }
            }
        }
    }
}
