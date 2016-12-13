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
        
//        let solidIcon = "\(hourlyWeather.icon)".nrd_weatherIconURL(highlighted: true)
//        let outlineIcon = "\(hourlyWeather.icon)".nrd_weatherIconURL()
        
        timeLbl.text = hourlyWeather.time
        if isTempF == true {
            tempLbl.text = "\(hourlyWeather.temperatureF)"
        }
        else {
            tempLbl.text = "\(hourlyWeather.temperatureC)"
        }
        tempLbl.roundTemperature()
        tempLbl.addDegreeSign()
        
        if hourlyWeather.isHigh == true {
            changeColor(color: warmColor)
        }
        
        if hourlyWeather.isLow == true {
            changeColor(color: coolColor)
        }
        
//        do {
//            let data = try Data(contentsOf: solidIcon!)
//            iconImage.image = UIImage(data: data)
//        } catch let err as Error {
//            print(err.localizedDescription)
//        }
        
        
    }
    
    func changeColor(color: UIColor) {
        
        timeLbl.textColor = color
        tempLbl.textColor = color
    }
    
    
}
