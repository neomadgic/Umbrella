//
//  DateHeaderView.swift
//  Umbrella
//
//  Created by Vu Dang on 12/9/16.
//  Copyright © 2016 Vu Dang. All rights reserved.
//

import UIKit

class DateHeaderView: UIView {
    
    override func awakeFromNib() {
        
        let topHeaderView = UIView(frame: createRect(yAxis: 0, height: 2))
        let bottomeHeaderView = UIView(frame: createRect(yAxis: 49, height: 1))
        
        setHeaderViewSettings(headerView: topHeaderView)
        setHeaderViewSettings(headerView: bottomeHeaderView)
    }
    
    func createRect(yAxis: Int, height: Int) -> CGRect {
        return CGRect(origin: CGPoint(x: 0,y: yAxis), size: CGSize(width: 1000, height: height))
    }
    
    func setHeaderViewSettings (headerView: UIView) {
        headerView.backgroundColor = headerColor
        headerView.clipsToBounds = true
        addSubview(headerView)
    }

}
