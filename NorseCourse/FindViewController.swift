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
                let b = sender as! UIButton
                
                resultsVC.category = b.currentTitle
            default: break
            }
        }
    }
}
