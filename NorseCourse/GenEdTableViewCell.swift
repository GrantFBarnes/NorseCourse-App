//
//  GenEdTableViewCell.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/19/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class GenEdTableViewCell: UITableViewCell {

    @IBOutlet weak var rowLabel: UILabel!

    var info: String? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        rowLabel?.attributedText = nil
        
        if let info = self.info {
            rowLabel?.text = info
        }
    }
}
