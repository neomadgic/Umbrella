//
//  DateCell.swift
//  Umbrella
//
//  Created by Vu Dang on 12/9/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: DayHeaderLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(day: String) {
        dayLabel.text = day
    }
}
