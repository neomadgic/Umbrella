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
    private var _conditionImageURL: String?
    private var _weatherURL: String!
    var weatherURL = WeatherRequest(APIKey: "189b51bbd050fc21")
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
    
    
    var conditionURL: String {
        
        if _conditionImageURL == nil {
            _conditionImageURL = ""
        }
        return _conditionImageURL!
    }
    
    init() {
        
    }
    
    init(zipCode: String) {
        
        self._zipCode = zipCode
        
        weatherURL.zipCode = zipCode
        
        _weatherURL = "\(URL_BASE)\(URL_WEATHER)\(zipCode).json"
        
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(self._weatherURL).responseJSON { response in switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    self._city = json["current_observation"]["display_location"]["full"].stringValue
                    self._currentTempF = json["current_observation"]["temp_f"].doubleValue
                    self._currentTempC = json["current_observation"]["temp_c"].doubleValue
                    self._currentCondition = json["current_observation"]["weather"].stringValue
                    
                    //Creating variables to find the date for today and tomorrow
                    //also created them to find min and max temps
                    let dayEnds = self.findWhenNewDayStarts(json: json)
                    var sizeOfTodayArray = 0
                    var todayTempArray = [Double]()
                    var tomorrowTempArray = [Double]()
                    
                    
                    //Set size of Today's array
                    if dayEnds - 1 < 7 {
                        sizeOfTodayArray = dayEnds - 1
                    }
                    else {
                        sizeOfTodayArray = 7
                    }
                    
                    //Create HourlyTodayArray
                    if dayEnds != 0 {
                        
                        for y in 0...sizeOfTodayArray {
                            let timeStr = json["hourly_forecast"][y]["FCTTIME"]["civil"].stringValue
                            let tempF = json["hourly_forecast"][y]["temp"]["english"].doubleValue
                            let tempC = json["hourly_forecast"][y]["temp"]["metric"].doubleValue
                            let icon = json["hourly_forecast"][y]["icon"].stringValue
                            let hourlyWeather = HourlyWeather(time: timeStr, tempF: tempF, tempC: tempC, icon: icon)
                        
                            self._hourlyTodayArray.append(hourlyWeather)
                            todayTempArray.append(tempF)
                        }
                    
                        //Create hourlyTomorrowArray
                        for z in dayEnds...(dayEnds + 7) {
                            let timeStr = json["hourly_forecast"][z]["FCTTIME"]["civil"].stringValue
                            let tempF = json["hourly_forecast"][z]["temp"]["english"].doubleValue
                            let tempC = json["hourly_forecast"][z]["temp"]["metric"].doubleValue
                            let icon = json["hourly_forecast"][z]["icon"].stringValue
                            let hourlyWeather = HourlyWeather(time: timeStr, tempF: tempF, tempC: tempC, icon: icon)
                        
                            self._hourlyTomorrowArray.append(hourlyWeather)
                            tomorrowTempArray.append(tempF)
                        }
                        
                        //Find Min and Max of todayTempArray
                        let maxToday = todayTempArray.max()
                        let minToday = todayTempArray.min()
                        let locationMaxToday = todayTempArray.index(of: maxToday!)!
                        let locationMinToday = todayTempArray.index(of: minToday!)!
                        
                        todayTempArray.sort()
                        if todayTempArray[0] != todayTempArray[1] {
                            self._hourlyTodayArray[locationMinToday].isLow = true
                        }
                        
                        todayTempArray.reverse()
                        if todayTempArray[0] != todayTempArray[1] {
                            self._hourlyTodayArray[locationMaxToday].isHigh = true
                        }
                        
                        //Find Min and Max of tomorrowTempArray
                        let maxTomorrow = tomorrowTempArray.max()
                        let minTomorrow = tomorrowTempArray.min()
                        let locationMaxTomorrow = tomorrowTempArray.index(of: maxTomorrow!)!
                        let locationMinTomorrow = tomorrowTempArray.index(of: minTomorrow!)!
                        
                        tomorrowTempArray.sort()
                        if tomorrowTempArray[0] != tomorrowTempArray[1] {
                            self._hourlyTomorrowArray[locationMinTomorrow].isLow = true
                        }
                        
                        tomorrowTempArray.reverse()
                        if tomorrowTempArray[0] != tomorrowTempArray[1] {
                            self._hourlyTomorrowArray[locationMaxTomorrow].isHigh = true
                        }
                        

                        //Add them to hourlyCombinedArray
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
    
}

