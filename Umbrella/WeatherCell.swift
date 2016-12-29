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
        
        //let serialQueue = DispatchQueue(label: "queuename")
        
        DispatchQueue.global(qos: .background).async {

            self.downloadImage(url: outlineIcon!, condition: hourlyWeather.icon, iconStatus: "outline")
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
                    
                    self.downloadImage(url: solidIcon!, condition: hourlyWeather.icon, iconStatus: "solid")
                    self.changeColor(color: warmColor)
                }
                
                if hourlyWeather.isLow == true {
                    
                    self.downloadImage(url: solidIcon!, condition: hourlyWeather.icon, iconStatus: "solid")
                    self.changeColor(color: coolColor)
                }

            }
        }
        
    }
    
    func changeColor(color: UIColor) {
        
        timeLbl.textColor = color
        tempLbl.textColor = color
        iconImage.image = iconImage.image!.withRenderingMode(.alwaysTemplate)
        iconImage.tintColor = color
    }
    
    func downloadImage(url: URL, condition: String, iconStatus: String) {
        
        let key = condition + iconStatus as NSString
        
        //check image cache
        if imageCache.object(forKey: key) != nil {
            let cacheImage = imageCache.object(forKey: key)! as UIImage
            iconImage.image = cacheImage
            return
        }
        
        //create image cache
        do {
            let data = try Data(contentsOf: url)
            imageCache.setObject(UIImage(data: data)!, forKey: key as NSString)
            iconImage.image = UIImage(data: data)
        } catch let err as Error {
                print(err.localizedDescription)
        }
        
    }
    
    
}
