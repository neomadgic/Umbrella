//
//  SettingsVC.swift
//  Umbrella
//
//  Created by Vu Dang on 12/9/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var blurredBGView: UIView!
    @IBOutlet weak var searchBarField: UITextField!
    
    
    var blurryBackgroundImage: UIImage!
    var tapCloseKeyboard: UITapGestureRecognizer?
    var tapCloseVC: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createBlurryBackground()
        createTapToHideKeyboard()
        createTapToCloseVC()
        
    }

    @IBAction func onGetWeatherBtnPressed(_ sender: Any) {
        
        if isSearchBarValid() {
            print("yay")
        }
    }
    
    func createBlurryBackground() {
        
        let imageView = UIImageView(image: blurryBackgroundImage)
        imageView.addBlurEffect()
        blurredBGView.addSubview(imageView)
    }
    
    func createTapToHideKeyboard() {
        
        tapCloseKeyboard = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.dismissKeyboard))
        tapCloseKeyboard!.cancelsTouchesInView = false
        view.addGestureRecognizer(tapCloseKeyboard!)
    }
    
    func createTapToCloseVC() {
        
        tapCloseVC = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.closeSettingsVC))
        blurredBGView.addGestureRecognizer(tapCloseVC!)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func closeSettingsVC() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func isSearchBarValid() -> Bool {
        
        if searchBarField.text != nil {
            
            let convertedToNumber = Double(searchBarField.text!)
            if searchBarField.text?.characters.count == 5 && convertedToNumber != nil {
                return true
            }
            else {
                //Number is not 5 digits or contains non digits
                return false
            }
        }
        else {
            print("enter something foo")
            return false
        }
    }
    

}

extension UIView {
    func addBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

