//
//  RoundedButton.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    
    func sharedInit() {
        refreshCorners()
    }
    
    func refreshCorners() {
        layer.cornerRadius = 10.0
    }
}
