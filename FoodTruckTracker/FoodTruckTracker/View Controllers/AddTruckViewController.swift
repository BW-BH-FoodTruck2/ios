//
//  AddTruckViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class AddTruckViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var truckNameTextField: UITextField!
	@IBOutlet weak var cuisineTypeTextField: UITextField!
	@IBOutlet weak var truckImageView: UIImageView!
    
    var vendor: VendorLogin?

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
        print(vendor)
		// Do any additional setup after loading the view.
	}

	// MARK: - Properties
	var truckController = TruckController.shared
	var cuisine: CuisineType?
	var imageURLString: String?
	var imagePickerController = UIImagePickerController()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CuisinePickerSegue":
            guard let cuisinePickerVC = segue.destination as? CuisinePickerViewController else { return }
            cuisinePickerVC.delegate = self
        default:
            break
        }
    }

	// MARK: - Actions
	@IBAction func addTruckButton(_ sender: UIBarButtonItem) {
		guard let truckName = truckNameTextField.text,
			!truckName.isEmpty,
			let cuisine = cuisineTypeTextField.text,
            !cuisine.isEmpty, let vendor = vendor, let bearer = vendor.bearer, let id = vendor.id else { return }
		let image = imageURLString ?? ""
        truckController.addTruck(with: bearer, name: truckName, imageURL: image, cuisineType: cuisine, operatorId: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        self.dismiss(animated: true, completion: nil)
	}
    
    private func showAlert(title: String, message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }

	@IBAction func addPhotoButton(_ sender: UIButton) {

		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = .photoLibrary
			imagePicker.allowsEditing = false
			present(imagePicker, animated: true, completion: nil)
		}
	}
    
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let truckImageUrl = info[.imageURL] as? URL else { return }
		imageURLString  = truckImageUrl.absoluteString

		do {
			let truckImageData = try Data(contentsOf: truckImageUrl)
			truckImageView.image = UIImage(data: truckImageData)
			dismiss(animated: true, completion: nil)
		} catch {
			NSLog("failed to get image")
		}
	}
}

extension AddTruckViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == cuisineTypeTextField {
			performSegue(withIdentifier: "CuisinePickerSegue", sender: self)
		}
	}
}

extension AddTruckViewController: CuisinePickerDelegate {
    func pickerDidPick(_ cuisineType: CuisineType) {
        cuisineTypeTextField.text = cuisineType.rawValue
    }
}
