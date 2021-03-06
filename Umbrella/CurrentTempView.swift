//
//  CurrentTempView.swift
//  Umbrella
//
//  Created by Vu Dang on 12/8/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

class CurrentTempView: UIView {
    
    override func awakeFromNib() {
        
        backgroundColor = UIColor.orgColor
        
    }
    
    func changeToCoolColor(currentTemp: Double) {
        if currentTemp < 60 {
            backgroundColor = UIColor.coolColor
        }
    }
}
