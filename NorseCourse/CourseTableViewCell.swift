//
//  CourseTableViewCell.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/14/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    var info: [String:AnyObject]? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        courseNameLabel?.attributedText = nil
        courseNumLabel?.attributedText = nil
        
        if let info = self.info {
            if info.keys.contains("title") {
                courseNumLabel?.text = String(info["name"]!)
                courseNameLabel?.text = String(info["title"]!)
            } else {
                courseNumLabel?.text = String(info["name"]!)
                courseNameLabel?.text = String(info["shortTitle"]!)
            }
        }
    }
}
