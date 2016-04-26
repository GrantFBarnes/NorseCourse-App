//
//  CoursesTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/14/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSections":
                let cell = sender as! CourseTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let cvc = segue.destinationViewController as! SectionViewController
                    cvc.course = courses[indexPath.row]
                }
                
            default: break
            }
        }
    }
    
    var courses = [[String:AnyObject]](){
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    var id: String?
    var selection: String?
    var category: String?
    var keyword: String?
    
    private func sortCourses(s1: [String:AnyObject], s2: [String:AnyObject]) -> Bool {
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
        
        if let category = category {
            switch category {
            case "Search by Department":
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let url = "https://norsecourse.com:5000/api/courses?departments="+self.id!
                    
                    let departmentsURL: NSURL = NSURL(string: url)!
                    if let data = NSData(contentsOfURL: departmentsURL) {
                    
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? Array<[String:AnyObject]> {
                                for course in dict {
                                    self.courses.append(self.elimnateNulls(course))
                                }
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                        
                        self.courses = self.courses.sort(self.sortCourses)
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
                
                
            case "Search by Gen Ed":
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let url = "https://norsecourse.com:5000/api/courses?genEds="+self.id!
                    
                    let genedsURL: NSURL = NSURL(string: url)!
                    if let data = NSData(contentsOfURL: genedsURL) {
                    
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? Array<[String:AnyObject]> {
                                for course in dict {
                                    self.courses.append(self.elimnateNulls(course))
                                }
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                        
                        self.courses = self.courses.sort(self.sortCourses)
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })

                
            case "Search by Faculty":
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let url = "https://norsecourse.com:5000/api/sections?facultyId="+self.id!
                    
                    let facultyURL: NSURL = NSURL(string: url)!
                    if let data = NSData(contentsOfURL: facultyURL) {
                    
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? Array<[String:AnyObject]> {
                                for course in dict {
                                    self.courses.append(self.elimnateNulls(course))
                                }
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                        
                        self.courses = self.courses.sort(self.sortCourses)
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
                
            
            case "Search by Keyword":
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let kw = self.keyword {
                        let keyword = kw.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                        
                        let url = "https://norsecourse.com:5000/api/courses?keywords="+keyword
                        
                        let keywordURL: NSURL = NSURL(string: url)!
                        if let data = NSData(contentsOfURL: keywordURL) {
                        
                            do {
                                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                                
                                if let dict = json as? Array<[String:AnyObject]> {
                                    for course in dict {
                                        self.courses.append(self.elimnateNulls(course))
                                    }
                                }
                                
                            } catch {
                                print("error serializing JSON: \(error)")
                            }
                            
                            self.courses = self.courses.sort(self.sortCourses)
                        } else {
                            let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(defaultAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                })
                
            default: break
                
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CourseTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Course", forIndexPath: indexPath) as! CourseTableViewCell
        
        // Configure the cell...
        cell.info = courses[indexPath.row]
        return cell
    }
}
