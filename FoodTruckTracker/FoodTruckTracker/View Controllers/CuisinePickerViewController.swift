//
//  CuisinePickerViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class CuisinePickerViewController: UIViewController {

	@IBOutlet private weak var cuisinePicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension AddTruckViewController: UIPickerViewDelegate, UIPickerViewDataSource {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
	return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
	return cuisinePickerData.count
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
	return cuisinePickerData[row].rawValue
}

public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
	let cuisineData = cuisinePickerData[row]
	let cuisine = NSAttributedString(string: cuisineData.rawValue,
                                     attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica",
                                                                                      size: 17.0)!,
                                                  NSAttributedString.Key.foregroundColor: UIColor.white])
	return cuisine
}
}
