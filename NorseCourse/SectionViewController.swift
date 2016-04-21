//
//  SectionViewController.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/14/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        if course.keys.contains("title") {
            updateUI()
        } else {
            getCourse()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSectionsTable":
                let cvc = segue.destinationViewController as! SectionTableViewController
                cvc.info = course
                
            default: break
            }
        }
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
    
    private func getCourse() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let url = "https://norsecourse.com:5000/api/courses/"+String(self.course["courseId"]!)
            let sectionURL: NSURL = NSURL(string: url)!
            let data = NSData(contentsOfURL: sectionURL)!
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let dict = json as? [String:AnyObject] {
                    self.course = self.elimnateNulls(dict)
                }
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            self.updateUI()
        })
    }
    
    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDescriptionLabel: UILabel!
    
    var course = [String:AnyObject]()

    private func updateUI() {
        
        courseNameLabel.attributedText = nil
        courseNumLabel.attributedText = nil
        courseDescriptionLabel.attributedText = nil
    
        if course.keys.contains("title") {
            courseNumLabel.text = String(course["name"]!)
            courseNameLabel.text = String(course["title"]!)
            if String(course["description"]!) == "nan" {
                courseDescriptionLabel.text = "* No course description *"
            } else {
                courseDescriptionLabel.text = String(course["description"]!)
            }
        } else {
            updateUI()
        }
    }
}
