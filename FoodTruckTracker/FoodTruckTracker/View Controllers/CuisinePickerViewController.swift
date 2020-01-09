//
//  CuisinePickerViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

protocol CuisinePickerDelegate: class {
    func pickerDidPick(_ cuisineType: CuisineType)
}

class CuisinePickerViewController: UIViewController {
    
    @IBOutlet weak var cuisinePicker: UIPickerView!
    var cuisinePickerData = [CuisineType]() {
        didSet {
            cuisinePicker.reloadAllComponents()
        }
    }
    weak var delegate: CuisinePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisinePicker.dataSource = self
        cuisinePicker.delegate = self
        setupPicker()
        print(cuisinePickerData.count)
    }
    
    private func setupPicker() {
        for cuisine in CuisineType.allCases {
            cuisinePickerData.append(cuisine)
        }
    }
}

extension CuisinePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuisinePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cuisinePickerData[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cuisine = cuisinePickerData[row]
        delegate?.pickerDidPick(cuisine)
        dismiss(animated: true)
    }
}
