//
//  SectionTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/14/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class SectionTableViewController: UITableViewController {

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
        getRows()
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var requiredCourses: [[String:AnyObject]] {
        get { return defaults.objectForKey("reqCourses") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqCourses") }
    }
    
    var preferredCourses: [[String:AnyObject]] {
        get { return defaults.objectForKey("prefCourses") as? [[String:AnyObject]] ?? [] }
        set {
            defaults.setObject(newValue, forKey: "prefCourses")
        }
    }
    
    var requiredSections: [[String:AnyObject]] {
        get { return defaults.objectForKey("reqSections") as? [[String:AnyObject]] ?? [] }
        set {
            defaults.setObject(newValue, forKey: "reqSections")
        }
    }
    
    var preferredSections: [[String:AnyObject]] {
        get { return defaults.objectForKey("prefSections") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefSections") }
    }
    
    var info = [String:AnyObject]()
    var sections = [[String:AnyObject]](){
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    
    private func sortSections(s1: [String:AnyObject], s2: [String:AnyObject]) -> Bool {
        return String(s1["name"]) < String(s2["name"])
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
    
    private func elimnateNulls(start: [String:AnyObject]) -> [String:AnyObject] {
        var new = [String:AnyObject]()
        for i in start.keys {
            if let temp = start[i]! as? String {
                new[i] = temp
            } else if let temp = start[i]! as? Int {
                new[i] = temp
            } else if let temp = start[i]! as? Double {
                new[i] = temp
            } else if let temp = start[i]! as? NSArray {
                var new_temp = [AnyObject]()
                for y in temp {
                    new_temp.append(elimnateNulls(y as! [String : AnyObject]))
                }
                
                new[i] = new_temp
            } else if let temp = start[i]! as? NSDictionary {
                new[i] = temp
            } else {
                new[i] = " "
            }
        }
        return new
    }
    
    private func getRows() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let url = "https://norsecourse.com:5000/api/sections?courses="+String(self.info["courseId"]!)
            let sectionURL: NSURL = NSURL(string: url)!
            if let data = NSData(contentsOfURL: sectionURL) {
            
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    
                    if let dict = json as? Array<[String:AnyObject]> {
                        for sect in dict {
                            self.sections.append(self.elimnateNulls(sect))
                        }
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
                self.sections = self.sections.sort(self.sortSections)
                
            } else {
                let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, not NorseCourses.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        
        let reqCAction = UIAlertAction(title: "Add to Required Courses", style: .Default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.requiredCourses.append(self.info)
        })
        
        let prefCAction = UIAlertAction(title: "Add to Preferred Courses", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.preferredCourses.append(self.info)
        })
        
        let reqSAction = UIAlertAction(title: "Add to Required Sections", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.requiredSections.append(self.sections[indexPath.row])
        })
        
        let prefSAction = UIAlertAction(title: "Add to Preferred Sections", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.preferredSections.append(self.sections[indexPath.row])
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(reqCAction)
        optionMenu.addAction(prefCAction)
        optionMenu.addAction(reqSAction)
        optionMenu.addAction(prefSAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SectionTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("section", forIndexPath: indexPath) as! SectionTableViewCell
        
        // Configure the cell...

        cell.info = sections[indexPath.row]
                
        return cell
    }
}
