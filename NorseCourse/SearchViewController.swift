//
//  SearchViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/15/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()

    }

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchText = ""
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        searchBar.resignFirstResponder()
        searchText = searchBar.text!
        performSegueWithIdentifier("showCourses", sender: searchButton)
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showCourses":
                let cvc = segue.destinationViewController as! CoursesTableViewController
                cvc.category = "Search by Keyword"
                cvc.keyword = searchText
                
            default: break
            }
        }
    }
}
