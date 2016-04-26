//
//  FindViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/12/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class FindViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()

    }
    
    @IBAction func askSortMethod(sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Sort Method", preferredStyle: .ActionSheet)
        
        
        let first = UIAlertAction(title: "Sort by First Initial", style: .Default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.sortMethod = "FI"
        })
        
        let last = UIAlertAction(title: "Sort by Last Name", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortMethod = "LN"
        })
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(first)
        optionMenu.addAction(last)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    
    var sortMethod: String? {
        didSet {
            performSegueWithIdentifier("showFaculty", sender: 0)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showDepartments":
                let resultsVC = segue.destinationViewController as! ResultsTableViewController
                let b = sender as! UIButton
                
                resultsVC.category = b.currentTitle
            case "showGenEds":
                let resultsVC = segue.destinationViewController as! ResultsTableViewController
                let b = sender as! UIButton
                
                resultsVC.category = b.currentTitle
            case "showFaculty":
                let resultsVC = segue.destinationViewController as! ResultsTableViewController
                resultsVC.category = "Search by Faculty"
                resultsVC.sortMethod = sortMethod
            default: break
            }
        }
    }
}
