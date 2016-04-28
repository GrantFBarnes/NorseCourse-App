//
//  GenEdTableViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class GenEdTableViewController: UITableViewController {

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

    @IBOutlet weak var label: UILabel!
    
    var genedsDic = [String:String]()
    var geneds = [String]() {
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
    
    
    var requiredGenEds: [String] {
        get { return information.requiredGenEds! }
        set { information.requiredGenEds = newValue }
    }
    
    var preferredGenEds: [String] {
        get { return information.preferredGenEds! }
        set { information.preferredGenEds = newValue }
    }
    
    
    private func getRows() {
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
    }


    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        
        let reqGEAction = UIAlertAction(title: "Add to Required Gen Eds", style: .Default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.requiredGenEds.append(self.geneds[indexPath.row])
        })
        
        let prefGEAction = UIAlertAction(title: "Add to Preferred Gen Eds", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.preferredGenEds.append(self.geneds[indexPath.row])
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(reqGEAction)
        optionMenu.addAction(prefGEAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geneds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GenEdTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Row", forIndexPath: indexPath) as! GenEdTableViewCell
        
        // Configure the cell...
        cell.info = geneds[indexPath.row]
        return cell
    }
}
