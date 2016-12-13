//
//  ViewController.swift
//  Umbrella
//
//  Created by Vu Dang on 12/8/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityLabel: CityLabel!
    @IBOutlet weak var currentTemperatureLbl: CurrentTemperatureLabel!
    @IBOutlet weak var currentConditionLbl: UILabel!
    @IBOutlet weak var currentTempView: CurrentTempView!
    
    
    
    var zipcode: String?
    var screenshot = UIImage()
    var isTempF = true
    var weather = Weather()
    var nestedArray = [[HourlyWeather]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
        
    }
    
    @IBAction func onSettingsBtnPressed(_ sender: Any) {
        
        createScreenShot()
        performSegue(withIdentifier: "SettingsVC", sender: screenshot)
    }
    
    func downloadWeather(zip: String) {
        
        let newWeather = Weather(zipCode: zip)
        weather = newWeather
        weather.downloadWeatherDetails {
            () -> () in
            self.updateLabels()
        }
    }
    
    func updateLabels() {
        
        cityLabel.text = weather.city
        if isTempF == true {
            currentTemperatureLbl.text = "\(weather.currentTempF)"
        }
        else {
            currentTemperatureLbl.text = "\(weather.currentTempC)"
        }
        currentTemperatureLbl.roundTemperature()
        currentTemperatureLbl.addDegreeSign()
        currentTempView.changeToCoolColor(currentTemp: weather.currentTempF)
        currentConditionLbl.text = weather.currentCondition
        collectionView.reloadData()
    }
    
    func createScreenShot() {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: false)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SettingsVC" {
            
            if let detailVC = segue.destination as? SettingsVC {
                
                if let blurredImage = sender as? UIImage {
                    
                    detailVC.blurryBackgroundImage = blurredImage
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return weather.hourlyCombinedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return weather.hourlyTodayArray.count
        return weather.hourlyCombinedArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            
            let hourlyWeather = weather.hourlyCombinedArray[indexPath.section][indexPath.row]
            cell.configureCell(hourlyWeather: hourlyWeather, isTempF: isTempF)
            return cell
        }
        else {
            return WeatherCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "WeatherHeaderView",
                                                                             for: indexPath) as! WeatherHeaderView
            if indexPath.section == 0 {
                headerView.DayHeaderLbl.text = "Today"
            }
            if indexPath.section == 1 {
                headerView.DayHeaderLbl.text = "Tomorrow"
            }
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
}
