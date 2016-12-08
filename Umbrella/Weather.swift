//
//  Weather.swift
//  Umbrella
//
//  Created by Vu Dang on 12/8/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    
    private var _zipCode: Int!
    private var _city: String?
    private var _currentTemp: Int?
    private var _currentCondition: String?
    private var _timeArray = [String]()
    private var _forecastTempatureArray = [Int]()
    private var _conditionImageURL: String?
    
    var zipCode: Int {
        return _zipCode
    }
    
    var city: String {
        
        if _city == nil {
            _city = ""
        }
        return _city!
    }
    
    var currentTemp: Int {
        
        if _currentTemp == nil {
            _currentTemp = 0
        }
        return _currentTemp!
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
    
    init(zipCode: Int) {
        
        self._zipCode = zipCode
    }
    
}
