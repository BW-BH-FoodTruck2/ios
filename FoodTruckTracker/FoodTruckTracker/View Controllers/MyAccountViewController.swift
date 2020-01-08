//
//  MyAccountViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    var vendor: VendorLogin? {
        didSet {
            updateViews()
        }
    }
    var consumer: ConsumerLogin? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        if let vendor = vendor, self.isViewLoaded {
            
        }
        
        if let consumer = consumer, self.isViewLoaded {
            
        }
    }
}
