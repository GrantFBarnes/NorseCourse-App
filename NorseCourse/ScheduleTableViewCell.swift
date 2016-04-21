//
//  ScheduleTableViewCell.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {


    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var meetingTimeLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!
    
    var section: [String:AnyObject]? {
        didSet {
            updateUI()
        }
    }
    
    var error: String? {
        didSet {
            updateUI()
        }
    }
    
    var load: Bool? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        courseNumLabel?.attributedText = nil
        courseNameLabel?.attributedText = nil
        meetingTimeLabel?.attributedText = nil
        professorLabel?.attributedText = nil
        loadLabel?.attributedText = nil
        
        if let l = load {
            if l {
                loadLabel?.text = "Load more schedules"
            }
        } else if let info = self.section {
            
            courseNumLabel?.text = String(info["name"]!)
            courseNameLabel?.text = String(info["shortTitle"]!)
            
            var meetingText = ""
            var check = true
            for i in 0..<info["sectionMeetings"]!.count {
                if i == info["sectionMeetings"]!.count-1 && i != 0 {
                    meetingText += ", and"
                } else if i > 0 {
                    meetingText += ", "
                }
                if String(info["sectionMeetings"]![i]["days"]!!) == "nan" {
                    check = false
                }
                meetingText += String(info["sectionMeetings"]![i]["days"]!!) + " "
                meetingText += String(info["sectionMeetings"]![i]["startTime"]!!) + "-"
                meetingText += String(info["sectionMeetings"]![i]["endTime"]!!) + " in "
                meetingText += String(info["sectionMeetings"]![i]["room"]!![i]["buildingName"]!!)
                meetingText += " " + String(info["sectionMeetings"]![i]["room"]!![i]["number"]!!)
                
            }
            
            if check {
                meetingTimeLabel?.text = meetingText
            } else {
                meetingTimeLabel?.text = "* No times for this course *"
            }
            
            
            var professorText = "Taught by: "
            check = true
            for i in 0..<info["faculty"]!.count {
                if i == info["faculty"]!.count-1 && i != 0 {
                    professorText += ", and"
                } else if i > 0 {
                    professorText += ", "
                }
                if String(info["faculty"]![i]["name"]!!) == "nan. nan" {
                    check = false
                }
                professorText += String(info["faculty"]![i]["name"]!!)
                
            }
            
            if check {
                professorLabel?.text = professorText
            } else {
                professorLabel?.text = "* No professor listed *"
            }
        } else {
            courseNumLabel?.text = "No Results"
            courseNameLabel?.text = ""
            meetingTimeLabel?.text = ""
            professorLabel?.text = ""
        }
    }
}
