//
//  SectionTableViewCell.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/14/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var sectionTimeLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    var info: [String:AnyObject]? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        sectionNameLabel?.attributedText = nil
        sectionTimeLabel?.attributedText = nil
        professorLabel?.attributedText = nil
        sectionTitleLabel?.attributedText = nil

        if let info = self.info {
            
            sectionNameLabel?.text = String(info["name"]!)
            sectionTitleLabel?.text = String(info["shortTitle"]!)
            
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
                sectionTimeLabel?.text = meetingText
            } else {
                sectionTimeLabel?.text = "* No times for this course *"
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
        }
    }
}
