//
//  CurrentTemperatureLabel.swift
//  Umbrella
//
//  Created by Vu Dang on 12/8/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import UIKit

class CurrentTemperatureLabel: UILabel {

    override func awakeFromNib() {

        roundTemperature()
        addDegreeSign()
    }
    
    func roundTemperature(){
        
        var roundedTemperature: Double?

        if text != "" {
            roundedTemperature = Double(text!)!
            roundedTemperature = round(roundedTemperature!)
            text = "\(Int(roundedTemperature!))"
        }
        else {
            text = ""
        }
    }
    
    func addDegreeSign() {
        if text != "" {
            text!.append("˚")
        }
        else {
            text = ""
        }
    }

}
