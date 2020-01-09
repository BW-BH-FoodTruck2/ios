//
//  MapViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

	@IBOutlet weak var foodTruckSearchBar: UISearchBar!
	@IBOutlet weak var searchResultsTableView: UITableView!
	@IBOutlet weak var foodTruckMapView: MKMapView!

	let locationManager = CLLocationManager()

		var searchResult: [TruckRepresentation] = []

		let vendorController = VendorController.shared
		let consumerController = ConsumerController.shared
		let truckController = TruckController.shared

		var directionsArray: [MKDirections] = []

		var userLocation: CLLocationCoordinate2D?

		override func viewDidLoad() {
			super.viewDidLoad()

			checkLocationServices()

			truckController.refreshTrucksFromServer()

			foodTruckSearchBar.showsCancelButton = false
			foodTruckSearchBar.delegate = self
			foodTruckSearchBar.resignFirstResponder()

			setupTableView()
		}

		override func viewDidAppear(_ animated: Bool) {
			super.viewDidAppear(animated)

//			checkForBearerToken()
		}

//		private func checkForBearerToken() {
//			if vendorController.token == nil && consumerController.token == nil {
//				performSegue(withIdentifier: "ModalLoginSegue", sender: self)
//			}
//		}

		private func setupTableView() { // Set up table view constaints and make it hidden
			searchResultsTableView.delegate = self
			searchResultsTableView.dataSource = self
			searchResultsTableView.isHidden = true
		}

		private func setupLocationManager() { // Housekeeping
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest // We want the best accuracy
		}

		private func centerViewOnUser() { // Grabs users current location and centers map onto location with 10,000 meters in each direction as padding
			if let location = locationManager.location?.coordinate {
				let region = MKCoordinateRegion(center: location, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
				foodTruckMapView.setRegion(region, animated: true)

				userLocation = location

			} else {
				NSLog("User appears to not have connection.")
			}
		}

		private func getDirections(to destination: CLLocationCoordinate2D) {
			// Gets directions from current location to selected destination. (Shows multiple routes)
			guard let location = locationManager.location?.coordinate else {
				let alert = UIAlertController(title: "", message: "Network error. Please check your connection", preferredStyle: .alert)
				self.present(alert, animated: true, completion: nil)

				let inFuture = DispatchTime.now() + 3
				DispatchQueue.main.asyncAfter(deadline: inFuture) {
				  alert.dismiss(animated: true, completion: nil)
				}
				return
			}

			let startingLocation = MKPlacemark(coordinate: location)
			let destinationLocation = MKPlacemark(coordinate: destination)

			let request = createRequest(start: startingLocation, end: destinationLocation)
			let directions = MKDirections(request: request)
			resetMap(withNew: directions)

			directions.calculate { [unowned self] response, error in
				if let error = error {
					NSLog("An error occured when getting directions: \(error)")
				}

				guard let response = response else {
					NSLog("Did not receive response when getting directions!")
					return
				}

				for route in response.routes {
					self.foodTruckMapView.addOverlay(route.polyline)
					self.foodTruckMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
				}
			}
		}

		func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
			let height: CGFloat = 100
			return height
		}

		private func createRequest(start: MKPlacemark, end: MKPlacemark) -> MKDirections.Request {
			let request = MKDirections.Request()
			request.source = MKMapItem(placemark: start)
			request.destination = MKMapItem(placemark: end)
			request.transportType = .automobile
			request.requestsAlternateRoutes = true

			return request
		}

		private func resetMap(withNew directions: MKDirections) {
			foodTruckMapView.removeOverlays(foodTruckMapView.overlays)
			for i in 0..<directionsArray.count {
				directionsArray[i].cancel()
				directionsArray.remove(at: i)
			}
			directionsArray.append(directions)
		}

		private func getAddress(_ location: CLLocation, completionHandler: @escaping (CLPlacemark?)
		-> Void ) {
			let geocoder = CLGeocoder()
			geocoder.reverseGeocodeLocation(location) { placemarks, error in
				if let error = error {
					NSLog("Error getting address from location: \(error)")
					completionHandler(nil)
				} else {
					if let placemarks = placemarks {
						completionHandler(placemarks[0])
					} else {
						completionHandler(nil)
					}
				}
			}
		}

		private func checkLocationServices() { // Check to make sure Location Services are active
			if CLLocationManager.locationServicesEnabled() {
				setupLocationManager()
				if checkLocationAuthorization() {
					centerViewOnUser()
				}
				locationManager.startUpdatingLocation()
			} else { // Alert user if Location Services are disabled and instruct on how to fix
				let alert = UIAlertController(title: "Location Services Disabled",
											  message: "It looks like location services is disabled. Please enable it in settings.",
											  preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
					if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
						// Open Location Services in settings if disabled
						UIApplication.shared.open(url)
					} else if let url = URL(string: UIApplication.openSettingsURLString) {
						// If Location Services url is changed in the future, open settings instead
						UIApplication.shared.open(url)
					}
				}))
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		}

		@discardableResult private func checkLocationAuthorization() -> Bool { // Check to see if user has authorized location tracking in app
			switch CLLocationManager.authorizationStatus() {
			case .authorizedAlways, .authorizedWhenInUse: // "Allow"
				foodTruckMapView.showsUserLocation = true // Only show location if user has allowed location tracking
				return true
			case .denied: // "Don't Allow"
				let alert = UIAlertController(title: "Location Permissions Disabled",
											  message: "It looks like location permission are disabled. Please enable them in settings.",
											  preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			case .notDetermined: // User has not yet viewed location tracking prompt
				locationManager.requestWhenInUseAuthorization()
			case .restricted: // User has parental controls on
				let alert = UIAlertController(title: "Location is Restricted", message: "It looks like location permission are restricted!", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			@unknown default: // Deal with any other case
				NSLog("Location services/permission status unknown. Please update to latest version of the app!")
			}
			return false
		}

	}

	extension MapViewController: CLLocationManagerDelegate {
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			// Periodically updates to always show user their current location
			guard let location = locations.last else { return }
			let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			let region = MKCoordinateRegion(center: center, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
			foodTruckMapView.setRegion(region, animated: true)
		}

		func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
			// Checks the auth status if it was changed
			checkLocationAuthorization()
		}
	}

	extension MapViewController: MKMapViewDelegate {
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			guard let olay = overlay as? MKPolyline else { return MKOverlayRenderer() }
			let renderer = MKPolylineRenderer(overlay: olay)
			renderer.strokeColor = .green

			return renderer
		}
	}

	extension MapViewController: UITableViewDataSource, UITableViewDelegate {
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return searchResult.count
		}

		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			guard let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "FoodTruckCell", for: indexPath) as? FoodTruckTableViewCell else { return UITableViewCell() }

			let truck = searchResult[indexPath.row]
			cell.truck = truck
//			getAddress(CLLocation(latitude: truck.location.latitude, longitude: truck.location.longitute)) { placemark in
//				if let placemark = placemark {
//					cell.address = placemark.locality // This may just show the city? There wasn't adiquate documentation
//				}
//			}

//			if let userLocation = userLocation {
//				let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
//				let destination = CLLocation(latitude: truck.location.latitude, longitude: truck.location.longitute)
//				let distance: CLLocationDistance = location.distance(from: destination)
//				cell.distanceAway = Double(distance) / 1609.344
//			}
			return cell
		}
	}

	extension MapViewController: UISearchBarDelegate {
		override func resignFirstResponder() -> Bool {
			return true
		}

		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			guard let text = searchBar.text else { return }
			if text.isEmpty {
				_ = searchBarShouldEndEditing(searchBar)
			}
		}

		func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
			UIView.animate(withDuration: 0.2) {
				self.searchResultsTableView.isHidden = false
				searchBar.showsCancelButton = true
			}
			return true
		}

		func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
			return true
		}

		func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
			searchBar.endEditing(false)
			searchResultsTableView.reloadData()
		}

		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			UIView.animate(withDuration: 0.2) {

				self.searchResultsTableView.isHidden = true
				searchBar.showsCancelButton = false
			}

			searchBar.text = ""

			self.view.endEditing(true)
		}
	}

//	extension MapViewController: ShowTruckOnMap {
//		func truckWasSelected(_ truck: TruckRepresentation) {
//			searchBarCancelButtonClicked(foodTruckSearchBar)
//			let coordinate = CLLocationCoordinate2D(latitude: truck.location.latitude, longitude: truck.location.longitute)
//			getDirections(to: coordinate)
//		}
//	}


