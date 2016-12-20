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
        
        let solidIcon = "\(hourlyWeather.icon)".nrd_weatherIconURL(highlighted: true)
        let outlineIcon = "\(hourlyWeather.icon)".nrd_weatherIconURL()
        
        DispatchQueue.global(qos: .background).async {
            self.downloadImage(url: outlineIcon!)
            DispatchQueue.main.async {
                self.iconImage.image = self.iconImage.image!.withRenderingMode(.alwaysTemplate)
                self.iconImage.tintColor = UIColor.black
                self.timeLbl.text = hourlyWeather.time
                if isTempF == true {
                    self.tempLbl.text = "\(hourlyWeather.temperatureF)"
                }
                else {
                    self.tempLbl.text = "\(hourlyWeather.temperatureC)"
                }
                self.tempLbl.roundTemperature()
                self.tempLbl.addDegreeSign()
                
                if hourlyWeather.isHigh == true {
                    
                    self.downloadImage(url: solidIcon!)
                    self.changeColor(color: warmColor)
                }
                
                if hourlyWeather.isLow == true {
                    
                    self.downloadImage(url: solidIcon!)
                    self.changeColor(color: coolColor)
                }

            }
        }
        
        
//        downloadImage(url: outlineIcon!)
//        iconImage.image = iconImage.image!.withRenderingMode(.alwaysTemplate)
//        iconImage.tintColor = UIColor.black
        
//        timeLbl.text = hourlyWeather.time
//        if isTempF == true {
//            tempLbl.text = "\(hourlyWeather.temperatureF)"
//        }
//        else {
//            tempLbl.text = "\(hourlyWeather.temperatureC)"
//        }
//        tempLbl.roundTemperature()
//        tempLbl.addDegreeSign()
//        
//        if hourlyWeather.isHigh == true {
//            
//            downloadImage(url: solidIcon!)
//            changeColor(color: warmColor)
//        }
//        
//        if hourlyWeather.isLow == true {
//            
//            downloadImage(url: solidIcon!)
//            changeColor(color: coolColor)
//        }
        
    }
    
    func changeColor(color: UIColor) {
        
        timeLbl.textColor = color
        tempLbl.textColor = color
        iconImage.image = iconImage.image!.withRenderingMode(.alwaysTemplate)
        iconImage.tintColor = color
    }
    
    func downloadImage(url: URL) {
        
        do {
            let data = try Data(contentsOf: url)
            iconImage.image = UIImage(data: data)
        } catch let err as Error {
            print(err.localizedDescription)
        }
    }
    
    
}
