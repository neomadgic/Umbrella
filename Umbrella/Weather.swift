//
//  Weather.swift
//  Umbrella
//
//  Created by Vu Dang on 12/8/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class Weather {
    
    private var _zipCode: String!
    private var _city: String?
    private var _currentTempF: Double?
    private var _currentTempC: Double?
    private var _currentCondition: String?
    private var _hourlyTodayArray = [HourlyWeather]()
    private var _hourlyTomorrowArray = [HourlyWeather]()
    private var _hourlyCombinedArray = [[HourlyWeather]]()
    private var _weatherURL: String!
    let URL_BASE = "http://api.wunderground.com"
    let URL_WEATHER = "/api/189b51bbd050fc21/conditions/hourly/q/"
    
    var zipCode: String {
        return _zipCode
    }
    
    var city: String {
        
        if _city == nil {
            _city = ""
        }
        return _city!
    }
    
    var currentTempF: Double {
        
        if _currentTempF == nil {
            _currentTempF = 0
        }
        return _currentTempF!
    }
    
    var currentTempC: Double {
        
        if _currentTempC == nil {
            _currentTempC = 0
        }
        return _currentTempC!
    }
    
    var currentCondition: String {
        
        if _currentCondition == nil {
            _currentCondition = ""
        }
        return _currentCondition!
    }
    
    var hourlyTodayArray: [HourlyWeather] {
        
        return _hourlyTodayArray
    }
    
    var hourlyTomorrowArray: [HourlyWeather] {
        
        return _hourlyTomorrowArray
    }
    
    var hourlyCombinedArray: [[HourlyWeather]] {
        return _hourlyCombinedArray
    }
    
    init() {
        
    }
    
    init(zipCode: String) {
        
        self._zipCode = zipCode
        
        _weatherURL = "\(URL_BASE)\(URL_WEATHER)\(zipCode).json"
        
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(self._weatherURL).responseJSON { response in switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    guard let cityFromJson = json["current_observation"]["display_location"]["full"].string else {
                            return
                    }
                    
                    self._city = cityFromJson
                    self._currentTempF = json["current_observation"]["temp_f"].doubleValue
                    self._currentTempC = json["current_observation"]["temp_c"].doubleValue
                    self._currentCondition = json["current_observation"]["weather"].stringValue
                    
                    //Creating variables to find the date for today and tomorrow
                    //also created them to find min and max temps
                    let dayEnds = self.findWhenNewDayStarts(json: json)
                    let sizeOfTodayArray = self.setSizeOfTodayArray(dayEnds: dayEnds)

                    if dayEnds != 0 {
                        
                        //Create Hourly Weather array and temperature array for today/tomorrow
                        self._hourlyTodayArray = self.createHourlyWeatherArray(startDayOfArray: 0, endDayOfArray: sizeOfTodayArray, json: json)
                        self._hourlyTomorrowArray = self.createHourlyWeatherArray(startDayOfArray: dayEnds, endDayOfArray: dayEnds + 7, json: json)
                        let todayTempArray = self.createTemperatureArray(hourlyWeatherArray: self.hourlyTodayArray)
                        let tomorrowTempArray = self.createTemperatureArray(hourlyWeatherArray: self.hourlyTomorrowArray)
                        
                        //Find today's hourly min
                        self._hourlyTodayArray[self.locationOfMin(tempArray: todayTempArray)].isLow = self.setIsLow(tempArray: todayTempArray)

                        //Find today's hourly max
                        self._hourlyTodayArray[self.locationOfMax(tempArray: todayTempArray)].isHigh = self.setIsHigh(tempArray: todayTempArray)

                        //Find tomorrow's hourly min
                        self._hourlyTomorrowArray[self.locationOfMin(tempArray: tomorrowTempArray)].isLow = self.setIsLow(tempArray: tomorrowTempArray)

                        //Find tomorrow's hourly max
                        self._hourlyTomorrowArray[self.locationOfMax(tempArray: tomorrowTempArray)].isHigh = self.setIsHigh(tempArray: tomorrowTempArray)
                        
                        self._hourlyCombinedArray.append(self.hourlyTodayArray)
                        self._hourlyCombinedArray.append(self.hourlyTomorrowArray)
                    }
                    
                    completed()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func findWhenNewDayStarts(json: JSON) -> Int {
        
        var dayArray = [Int]()
        var currentDay: Int
        for x in 0...24 {
            currentDay = json["hourly_forecast"][x]["FCTTIME"]["mday"].intValue
            dayArray.append(currentDay)
            if x > 0 {
                if dayArray[x] != dayArray[x-1] {
                    return x
                }
            }
        }
        
        return 0
    }
    
    func setSizeOfTodayArray(dayEnds: Int) -> Int {
        
        if dayEnds - 1 < 7 {
            return dayEnds - 1
        }
        else {
            return 7
        }
    }
    
    func createHourlyWeatherArray(startDayOfArray: Int, endDayOfArray: Int, json: JSON) -> [HourlyWeather] {
        
        var tempArray = [HourlyWeather]()
    
        for y in startDayOfArray...endDayOfArray {
                let timeStr = json["hourly_forecast"][y]["FCTTIME"]["civil"].stringValue
                let tempF = json["hourly_forecast"][y]["temp"]["english"].doubleValue
                let tempC = json["hourly_forecast"][y]["temp"]["metric"].doubleValue
                let icon = json["hourly_forecast"][y]["icon"].stringValue
                let hourlyWeather = HourlyWeather(time: timeStr, tempF: tempF, tempC: tempC, icon: icon)
            
                tempArray.append(hourlyWeather)
        }
        
        return tempArray
    }
    
    func createTemperatureArray(hourlyWeatherArray: [HourlyWeather]) -> [Double] {
        
        var tempArray = [Double]()
        
        for x in 0...(hourlyWeatherArray.count - 1) {
            tempArray.append(hourlyWeatherArray[x].temperatureF)
        }
        
        return tempArray
    }
    
    func setIsLow(tempArray: [Double]) -> Bool {
        
        let sortedArray = tempArray.sorted()
        if sortedArray[0] != sortedArray[1] {
            return true
        }
        else {
            return false
        }
    }
    
    func setIsHigh(tempArray: [Double]) -> Bool {
        
        let sortedArray = tempArray.sorted(by: >)
        if sortedArray[0] != sortedArray[1] {
            return true
        }
        else {
            return false
        }
    }
    
    func locationOfMin(tempArray: [Double]) -> Int {
        
        return tempArray.index(of: tempArray.min()!)!
    }
    
    func locationOfMax(tempArray: [Double]) -> Int {
        
        return tempArray.index(of: tempArray.max()!)!
    }

}

