//
//  SavedScheduleTableViewCell.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/21/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class SavedScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var meetingTimeLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    
    var section: [String:String]? {
        didSet {
            updateUI()
        }
    }
    
    var nothing: Bool? {
        didSet {
            showNothing()
        }
    }
    
    func showNothing() {
        courseNumLabel?.attributedText = nil
        courseNameLabel?.attributedText = nil
        meetingTimeLabel?.attributedText = nil
        professorLabel?.attributedText = nil
        
        courseNumLabel?.text = "No Saved Schedules"
        courseNameLabel?.text = ""
        meetingTimeLabel?.text = ""
        professorLabel?.text = ""
        
    }
    
    func updateUI() {
        courseNumLabel?.attributedText = nil
        courseNameLabel?.attributedText = nil
        meetingTimeLabel?.attributedText = nil
        professorLabel?.attributedText = nil

        
        if let info = self.section {
            
            courseNumLabel?.text = info["num"]
            courseNameLabel?.text = info["name"]
            meetingTimeLabel?.text = info["meetingTime"]
            professorLabel?.text = info["professor"]

        }
    }
}
