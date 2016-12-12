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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self

        if zipcode != nil {
            
            downloadWeather(zip: zipcode!)
        }

    }
    
    @IBAction func onSettingsBtnPressed(_ sender: Any) {
        
        createScreenShot()
        performSegue(withIdentifier: "SettingsVC", sender: screenshot)
    }
    
    func downloadWeather(zip: String) {
        
        let weather = Weather(zipCode: zip)
        //weather = newWeather
        weather.downloadWeatherDetails {
            () -> () in
            self.updateLabels(weather: weather)
        }
    }
    
    func updateLabels(weather: Weather) {
        
        cityLabel.text = weather.city
        currentTemperatureLbl.text = "\(weather.currentTempF)"
        currentTemperatureLbl.roundTemperature()
        currentTemperatureLbl.addDegreeSign()
        currentTempView.changeToCoolColor(currentTemp: weather.currentTempF)
        currentConditionLbl.text = weather.currentCondition
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "WeatherHeaderView",
                                                                             for: indexPath) as! WeatherHeaderView
            headerView.DayHeaderLbl.text = "Today"
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
}
