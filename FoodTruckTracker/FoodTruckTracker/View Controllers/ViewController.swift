//
//  ViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/6/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
