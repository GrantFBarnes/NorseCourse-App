//
//  ResultsTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/14/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

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
            case "showCourses":
                let cell = sender as! ResultsTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let cvc = segue.destinationViewController as! CoursesTableViewController
                    cvc.category = category
                    if let category = category {
                        switch category {
                        case "Search by Department":
                            cvc.selection = departments[indexPath.row]
                            cvc.id = departmentsDic[departments[indexPath.row]]
                        case "Search by Gen Ed":
                            cvc.selection = geneds[indexPath.row]
                            cvc.id = genedsDic[geneds[indexPath.row]]
                        case "Search by Faculty":
                            if sortMethod == "FI" {
                                cvc.selection = faculty[indexPath.row]
                                cvc.id = facultyDic[faculty[indexPath.row]]
                            } else {
                                cvc.selection = lastNameFaculty[indexPath.row]
                                let name = changeOrder(lastNameFaculty[indexPath.row])
                                cvc.id = facultyDic[name]
                            }
                        default: cvc.selection = ""
                        }
                    }
                }

            default: break
            }
        }
    }
    
    var departmentsDic = [String:String]()
    var departments = [String]() {
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    var genedsDic = [String:String]()
    var geneds = [String]() {
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    var facultyDic = [String:String]()
    var faculty = [String]() {
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    var lastNameFaculty = [String]() {
        didSet {
            tableView.reloadData()
            refresh()
        }
    }
    
    var category: String?
    var sortMethod: String?
    
    
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
    
    
    private func changeOrder(name: String) -> String {
        var string = ""

        for person in name.componentsSeparatedByString(", ") {
            if string != "" {
                string += ","
            }
            let nameArr = person.componentsSeparatedByString(". ")
            if nameArr.count == 2 {
                string += nameArr[1] + "." + nameArr[0]
            }
        }
        return string
    }
    
    
    private func sortFaculty(names: [String]) -> [String] {

        for name in names {
            var string = ""
            for person in name.componentsSeparatedByString(",") {
                if string != "" {
                    string += ", "
                }
                let nameArr = person.componentsSeparatedByString(".")
                if nameArr.count == 2 {
                    string += nameArr[1] + ". " + nameArr[0]
                }
            }
            if string != "" {
                lastNameFaculty.append(string)
            }
        }
        
        lastNameFaculty = lastNameFaculty.sort()
        return lastNameFaculty
    }
    
    
    
    private func getRows() {

        if let category = category {
            switch category {
            case "Search by Department":
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let departmentsURL: NSURL = NSURL(string: "https://norsecourse.com:5000/api/departments")!
                    if let data = NSData(contentsOfURL: departmentsURL) {
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? Array<[String:AnyObject]> {
                                for depart in dict {
                                    self.departmentsDic["\(depart["name"]!)"] = "\(depart["departmentId"]!)"
                                }
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                        self.departments = self.departmentsDic.keys.sort()
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
                
                
            case "Search by Gen Ed":
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let genedURL: NSURL = NSURL(string: "https://norsecourse.com:5000/api/genEds")!
                    if let data = NSData(contentsOfURL: genedURL) {
                    
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? Array<[String:AnyObject]> {
                                for ge in dict {
                                    self.genedsDic["\(ge["abbreviation"]!)" + " - " + "\(ge["name"]!)"] = "\(ge["genEdId"]!)"
                                }
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                        self.geneds = self.genedsDic.keys.sort()
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })

                
            case "Search by Faculty":
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let facultyURL: NSURL = NSURL(string: "https://norsecourse.com:5000/api/faculty")!
                    if let data = NSData(contentsOfURL: facultyURL) {
                    
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let dict = json as? Array<[String:AnyObject]> {
                                for f in dict {
                                    self.facultyDic["\(f["name"]!)"] = "\(f["facultyId"]!)"
                                }
                            }
                            
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                        self.faculty = self.facultyDic.keys.sort()
                        self.lastNameFaculty = self.sortFaculty(self.faculty)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "There appears to be a network error. This is your problem to fix, or Blaise has unplugged his blaising fast server.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            default: break
            
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let category = category {
            switch category {
            case "Search by Department":
                return departments.count
            case "Search by Gen Ed":
                return geneds.count
            case "Search by Faculty":
                if sortMethod == "FI" {
                    return faculty.count
                } else {
                    return lastNameFaculty.count
                }
            default: return 0
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ResultsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Row", forIndexPath: indexPath) as! ResultsTableViewCell
        
        // Configure the cell...
        if let category = category {
            switch category {
            case "Search by Department":
                cell.info = departments[indexPath.row]
            case "Search by Gen Ed":
                cell.info = geneds[indexPath.row]
            case "Search by Faculty":
                if sortMethod == "FI" {
                    cell.info = faculty[indexPath.row]
                } else {
                    cell.info = lastNameFaculty[indexPath.row]
                }
            default: cell.info = ""
            }
        }
        return cell
    }
}
