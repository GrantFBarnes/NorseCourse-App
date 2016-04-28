//
//  SavedSchedulesTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/21/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class SavedSchedulesTableViewController: UITableViewController {
    
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
    }
    
    @IBAction func clearSavedSchedules(sender: UIButton) {
        savedSchedules = []
        refresh()
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
    
    var savedSchedules: [[[String:String]]] {
        get { return information.savedSchedules! }
        set {
            information.savedSchedules = newValue
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if savedSchedules.count == 0 {
            return 1
        }
        
        return savedSchedules.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedSchedules.count == 0 {
            return 1
        }
        
        return savedSchedules[section].count
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 0.92)
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if savedSchedules.count > 0 {
            return "Schedule #"+String(section+1)
        }
        return "No Saved Schedules"
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SavedScheduleTableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("savedCell", forIndexPath: indexPath) as! SavedScheduleTableViewCell
        if savedSchedules.count > 0 {
            cell.section = savedSchedules[indexPath.section][indexPath.row]
        } else {
            cell.nothing = true
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if savedSchedules.count > 0 {
            let optionMenu = UIAlertController(title: nil, message: "Remove Schedule?", preferredStyle: .ActionSheet)
            
            
            let saveAction = UIAlertAction(title: "Remove from Saved Schedules", style: .Destructive, handler:{
                (alert: UIAlertAction!) -> Void in
                self.savedSchedules.removeAtIndex(indexPath.section)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
}
