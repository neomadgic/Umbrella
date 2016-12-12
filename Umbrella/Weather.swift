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
    private var _timeArray = [String]()
    private var _forecastTempatureArray = [Int]()
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
            _currentTempF = 1337
        }
        return _currentTempF!
    }
    
    var currentTempC: Double {
        
        if _currentTempC == nil {
            _currentTempC = 1337
        }
        return _currentTempC!
    }
    
    var currentCondition: String {
        
        if _currentCondition == nil {
            _currentCondition = ""
        }
        return _currentCondition!
    }
    
    var timeArray: [String] {
        return _timeArray
    }
    
    var forecastTemperatureArray: [Int] {
        return _forecastTempatureArray
    }
    
    var conditionURL: String? {
        
        if _conditionImageURL == nil {
            _conditionImageURL = ""
        }
        return _conditionImageURL
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

                    completed()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
