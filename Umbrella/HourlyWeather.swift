//
//  HourlyWeather.swift
//  Umbrella
//
//  Created by Vu Dang on 12/12/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import Foundation

class HourlyWeather {
    
    private var _time: String?
    private var _temperatureF: Double?
    private var _temperatureC: Double?
    private var _icon: String?
    
    var isHigh = false
    var isLow = false
    
    var time: String {
        
        if _time == nil {
            _time = ""
        }
        return _time!
    }
    
    var temperatureF: Double {
        
        if _temperatureF == nil {
            _temperatureF = 0
        }
        
        return _temperatureF!
    }
    
    var temperatureC: Double {
        
        if _temperatureF == nil {
            _temperatureF = 0
        }
        
        return _temperatureC!
    }
    
    var icon: String {
        
        if _icon == nil {
            _icon = ""
        }
        
        return _icon!
    }
    
    init(time: String, tempF: Double, tempC: Double, icon: String) {
        
        self._time = time
        self._temperatureF = tempF
        self._temperatureC = tempC
        self._icon = icon
    }
    
    
}
