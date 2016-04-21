//
//  PlanTableViewCell.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionTimeLabel: UILabel!
    @IBOutlet weak var sectionProfessorLabel: UILabel!
    
    @IBOutlet weak var genEdLabel: UILabel!
    
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var requiredCourses: [[String:AnyObject]] {
        get { return defaults.objectForKey("reqCourses") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqCourses") }
    }
    
    var preferredCourses: [[String:AnyObject]] {
        get { return defaults.objectForKey("prefCourses") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefCourses") }
    }
    
    var requiredSections: [[String:AnyObject]] {
        get { return defaults.objectForKey("reqSections") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqSections") }
    }
    
    var preferredSections: [[String:AnyObject]] {
        get { return defaults.objectForKey("prefSections") as? [[String:AnyObject]] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefSections") }
    }
    
    var requiredGenEds: [String] {
        get { return defaults.objectForKey("reqGenEds") as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: "reqGenEds") }
    }
    
    var preferredGenEds: [String] {
        get { return defaults.objectForKey("prefGenEds") as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: "prefGenEds") }
    }

    
    var section: String? {
        didSet {
            updateUI()
        }
    }
    
    var index: NSIndexPath? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        courseNumLabel?.attributedText = nil
        courseNameLabel?.attributedText = nil
        sectionNameLabel?.attributedText = nil
        sectionTitleLabel?.attributedText = nil
        sectionTimeLabel?.attributedText = nil
        sectionProfessorLabel?.attributedText = nil
        genEdLabel?.attributedText = nil
        
        courseNumLabel?.alpha = 1.0
        courseNameLabel?.alpha = 1.0
        sectionNameLabel?.alpha = 1.0
        sectionTitleLabel?.alpha = 1.0
        sectionTimeLabel?.alpha = 1.0
        sectionProfessorLabel?.alpha = 1.0
        genEdLabel?.alpha = 1.0
        
        if section == "Required Courses" {
            if requiredCourses.count > 0 {
                if let row = index?.row {
                    courseNumLabel?.text = String(requiredCourses[row]["name"]!)
                    courseNameLabel?.text = String(requiredCourses[row]["title"]!)
                }
            } else {
                courseNameLabel?.alpha = 0.3
                courseNumLabel?.alpha = 0.3
                courseNumLabel?.text = "No Required Course Set"
                courseNameLabel?.text = "Go to find tab to add some"
            }
        }
        
        
        
        if section == "Required Sections" {
            if requiredSections.count > 0 {
                if let row = index?.row {
                    
                    sectionNameLabel?.text = String(requiredSections[row]["name"]!)
                    sectionTitleLabel?.text = String(requiredSections[row]["shortTitle"]!)
                    
                    
                    var meetingText = ""
                    var check = true
                    for i in 0..<requiredSections[row]["sectionMeetings"]!.count {
                        if i == requiredSections[row]["sectionMeetings"]!.count-1 && i != 0 {
                            meetingText += ", and"
                        } else if i > 0 {
                            meetingText += ", "
                        }
                        if String(requiredSections[row]["sectionMeetings"]![i]["days"]!!) == "nan" {
                            check = false
                        }
                        meetingText += String(requiredSections[row]["sectionMeetings"]![i]["days"]!!) + " "
                        meetingText += String(requiredSections[row]["sectionMeetings"]![i]["startTime"]!!) + "-"
                        meetingText += String(requiredSections[row]["sectionMeetings"]![i]["endTime"]!!) + " in "
                        meetingText += String(requiredSections[row]["sectionMeetings"]![i]["room"]!![i]["buildingName"]!!)
                        meetingText += " " + String(requiredSections[row]["sectionMeetings"]![i]["room"]!![i]["number"]!!)
                        
                    }
                    
                    if check {
                        sectionTimeLabel?.text = meetingText
                    } else {
                        sectionTimeLabel?.text = "* No times for this course *"
                    }
                    
                    
                    var professorText = "Taught by: "
                    check = true
                    for i in 0..<requiredSections[row]["faculty"]!.count {
                        if i == requiredSections[row]["faculty"]!.count-1 && i != 0 {
                            professorText += ", and"
                        } else if i > 0 {
                            professorText += ", "
                        }
                        if String(requiredSections[row]["faculty"]![i]["name"]!!) == "nan. nan" {
                            check = false
                        }
                        professorText += String(requiredSections[row]["faculty"]![i]["name"]!!)
                        
                    }
                    
                    if check {
                        sectionProfessorLabel?.text = professorText
                    } else {
                        sectionProfessorLabel?.text = "* No professor listed *"
                    }
                    
                    
                }
            } else {
                sectionNameLabel?.alpha = 0.3
                sectionTitleLabel?.alpha = 0.3
                sectionNameLabel?.text = "No Required Section Set"
                sectionTitleLabel?.text = "Go to find tab to add some"
                sectionTimeLabel?.text = ""
                sectionProfessorLabel?.text = ""
            }
        }
        
        
        
        if section == "Preferred Courses" {
            if preferredCourses.count > 0 {
                if let row = index?.row {
                    courseNumLabel?.text = String(preferredCourses[row]["name"]!)
                    courseNameLabel?.text = String(preferredCourses[row]["title"]!)
                }
            } else {
                courseNumLabel?.alpha = 0.3
                courseNameLabel?.alpha = 0.3
                courseNumLabel?.text = "No Preferred Course Set"
                courseNameLabel?.text = "Go to find tab to add some"
            }
        }
        
        
        
        if section == "Preferred Sections" {
            if preferredSections.count > 0 {
                if let row = index?.row {
                    
                    sectionNameLabel?.text = String(preferredSections[row]["name"]!)
                    sectionTitleLabel?.text = String(preferredSections[row]["shortTitle"]!)
                    
                    
                    var meetingText = ""
                    var check = true
                    for i in 0..<preferredSections[row]["sectionMeetings"]!.count {
                        if i == preferredSections[row]["sectionMeetings"]!.count-1 && i != 0 {
                            meetingText += ", and"
                        } else if i > 0 {
                            meetingText += ", "
                        }
                        if String(preferredSections[row]["sectionMeetings"]![i]["days"]!!) == "nan" {
                            check = false
                        }
                        meetingText += String(preferredSections[row]["sectionMeetings"]![i]["days"]!!) + " "
                        meetingText += String(preferredSections[row]["sectionMeetings"]![i]["startTime"]!!) + "-"
                        meetingText += String(preferredSections[row]["sectionMeetings"]![i]["endTime"]!!) + " in "
                        meetingText += String(preferredSections[row]["sectionMeetings"]![i]["room"]!![i]["buildingName"]!!)
                        meetingText += " " + String(preferredSections[row]["sectionMeetings"]![i]["room"]!![i]["number"]!!)
                        
                    }
                    
                    if check {
                        sectionTimeLabel?.text = meetingText
                    } else {
                        sectionTimeLabel?.text = "* No times for this course *"
                    }
                    
                    
                    var professorText = "Taught by: "
                    check = true
                    for i in 0..<preferredSections[row]["faculty"]!.count {
                        if i == preferredSections[row]["faculty"]!.count-1 && i != 0 {
                            professorText += ", and"
                        } else if i > 0 {
                            professorText += ", "
                        }
                        if String(preferredSections[row]["faculty"]![i]["name"]!!) == "nan. nan" {
                            check = false
                        }
                        professorText += String(preferredSections[row]["faculty"]![i]["name"]!!)
                        
                    }
                    
                    if check {
                        sectionProfessorLabel?.text = professorText
                    } else {
                        sectionProfessorLabel?.text = "* No professor listed *"
                    }
                    
                    
                }
            } else {
                sectionNameLabel?.alpha = 0.3
                sectionTitleLabel?.alpha = 0.3
                sectionNameLabel?.text = "No Preferred Section Set"
                sectionTitleLabel?.text = "Go to find tab to add some"
                sectionTimeLabel?.text = ""
                sectionProfessorLabel?.text = ""
            }
        }
        
        
        if section == "Required Gen Eds" {
            if requiredGenEds.count > 0 {
                if let row = index?.row {
                    genEdLabel?.text = String(requiredGenEds[row])
                }
            } else {
                genEdLabel?.alpha = 0.3
                genEdLabel?.text = "No Required Gen Ed Set"
            }
        }
        
        
        if section == "Preferred Gen Eds" {
            if preferredGenEds.count > 0 {
                if let row = index?.row {
                    if row < preferredGenEds.count {
                        genEdLabel?.text = String(preferredGenEds[row])
                    }
                }
            } else {
                genEdLabel?.alpha = 0.3
                genEdLabel?.text = "No Preferred Gen Ed Set"
            }
        }
    }
}
