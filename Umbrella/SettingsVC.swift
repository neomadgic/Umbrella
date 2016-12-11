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
    
    var blurryBackgroundImage: UIImage!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createBlurryBackground()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.dismissKeyboard))
        createTapToHideKeyboard(tap: tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func createTapToHideKeyboard(tap: UIGestureRecognizer) {
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func createBlurryBackground() {
        
        let imageView = UIImageView(image: blurryBackgroundImage)
        imageView.addBlurEffect()
        blurredBGView.addSubview(imageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
