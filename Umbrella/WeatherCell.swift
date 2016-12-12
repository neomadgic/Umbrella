//
//  WeatherCell.swift
//  Umbrella
//
//  Created by Vu Dang on 12/9/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tempLbl: CurrentTemperatureLabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(hourlyWeather: HourlyWeather, isTempF: Bool){
        
        timeLbl.text = hourlyWeather.time
        if isTempF == true {
            tempLbl.text = "\(hourlyWeather.temperatureF)"
        }
        else {
            tempLbl.text = "\(hourlyWeather.temperatureC)"
        }
        tempLbl.roundTemperature()
        tempLbl.addDegreeSign()
        
    }
    
    
}
