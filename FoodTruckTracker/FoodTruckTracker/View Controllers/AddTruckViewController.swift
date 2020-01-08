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

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	// MARK: - Properties
	var truckController = TruckController.shared
	var cuisine: CuisineType?
	var imageURLString: String?
	var cuisinePickerData: [CuisineType] = []
	var cuisinePicker: UIPickerView! = UIPickerView()
	var imagePickerController = UIImagePickerController()

//	var truckRep: TruckRepresentation {
//		let moc = CoreDataStack.shared.mainContext
//		let request: NSFetchRequest<Truck> = Truck.fetchRequest()
//
//		do {
//			let trucks = try moc.fetch(request)
//			if let truck = trucks.first,
//				let truckRep = truck.truckRepresentation {
//				return truckRep			}
//		} catch {
//			fatalError("Error fetching truck: \(error)")
//		}
//		return TruckRepresentation()
//	}

	// MARK: - Actions
	@IBAction func addTruckButton(_ sender: UIBarButtonItem) {
		guard let truckName = truckNameTextField.text,
			!truckName.isEmpty,
			let cuisine = cuisineTypeTextField.text,
			!cuisine.isEmpty else { return }
		guard let image = imageURLString else { return }
		print(image)
//		truckController.createTruck(with: truckName, location: Location(longitude: 0.0, latitude: 0.0), imageOfTruck: image)
		dismiss(animated: true, completion: nil)
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

	private func setupPicker() {

		//cuisinePicker.delegate = self as UIPickerViewDelegate
		//cuisinePicker.dataSource = self as UIPickerViewDataSource
		self.view.addSubview(cuisinePicker)
		cuisinePicker.center = self.view.center
		// Sets Cuisine Picker View
		cuisinePicker.backgroundColor = UIColor.textWhite

		// Sets Cuisine delegate and datasource
		cuisinePicker.dataSource = self
		cuisinePicker.delegate = self

		// Sets the textfields
		cuisineTypeTextField.inputView = cuisinePicker
		for cuisine in CuisineType.allCases {
			cuisinePickerData.append(cuisine)
		}
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == cuisineTypeTextField {
			performSegue(withIdentifier: "CuisinePickerSegue", sender: self)
		}
	}
}
