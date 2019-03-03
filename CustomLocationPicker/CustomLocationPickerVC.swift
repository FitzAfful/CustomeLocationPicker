//
//  ViewController.swift
//  CustomLocationPicker
//
//  Created by Paa Quesi Afful on 02/03/2019.

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class CustomLocationPickerVC: UIViewController, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
	
	
	private var selectedPlace: GMSPlace?
	
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var googleMapView: GMSMapView!
	@IBOutlet weak var viewAddressContainer: UIView!
	@IBOutlet weak var buttonSetAddress: UIButton!
	var address = ""
	var lat = ""
	var lng = ""
	var city = ""
	var country = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		city = ""
		country = ""
		
		// Do any additional setup after loading the view.
		title = "SELECT ADDRESS"
		setRightBarButtonItemWithTitle(nil, andBackGroundImage: UIImage(named: "search"), andSelector: #selector(CustomLocationPickerVC.searchButtonAction), withTarget: self, on: self)
		
		navigationController?.isNavigationBarHidden = false
		var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
		center.latitude = CLLocationDegrees(Double(lat) ?? 0.0)
		center.longitude = CLLocationDegrees(Double(lng) ?? 0.0)
		
		addressLabel.text = address
		let camera = GMSCameraPosition.camera(withLatitude: Double(lat) ?? 0.0, longitude: Double(lng) ?? 0.0, zoom: 16)
		googleMapView.camera = camera
		googleMapView.isMyLocationEnabled = true
		googleMapView.delegate = self
		//_googleMapView.padding = UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0);
		viewAddressContainer.layer.cornerRadius = 25.0
		viewAddressContainer.layer.borderWidth = 1.0
		viewAddressContainer.layer.borderColor = UIColor(red: 28.0 / 255.0, green: 181.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0).cgColor
	}
	
	@objc func setRightBarButtonItemWithTitle(_ title: String?, andBackGroundImage backImage: UIImage?, andSelector selector: Selector, withTarget target: Any?, on controller: UIViewController?) {
		
		let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
		rightBtn.setTitle(title, for: .normal)
		rightBtn.addTarget(target, action: selector, for: .touchUpInside)
		
		if backImage != nil {
			rightBtn.setImage(backImage, for: .normal)
			if let font = UIFont(name: "Helvetica Neue", size: 10.0) {
				rightBtn.titleLabel?.font = font
			}
			rightBtn.setTitleColor(UIColor.white, for: .normal)
			rightBtn.contentHorizontalAlignment = .right
			
			rightBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		} else {
			rightBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
			
			rightBtn.contentHorizontalAlignment = .right
			rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
			rightBtn.setTitleColor(UIColor(red: 28.0 / 255.0, green: 181.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0), for: .normal)
		}
		
		let rightBtnItem = UIBarButtonItem(customView: rightBtn)
		controller?.navigationItem.rightBarButtonItem = rightBtnItem
	}
	
	@objc func searchButtonAction() {
		selectedPlace = nil
		let acController = GMSAutocompleteViewController()
		acController.delegate = self
		present(acController, animated: true)
	}
	
	func backButtonAction() {
		navigationController?.popViewController(animated: true)
	}
	
	func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
		
		if selectedPlace != nil {
			selectedPlace = nil
			return
		}
		let latitude = mapView.camera.target.latitude
		let longitude = mapView.camera.target.longitude
		let addressCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
		let coder = GMSGeocoder()
		coder.reverseGeocodeCoordinate(addressCoordinates, completionHandler: { results, error in
			if error != nil {
				self.country = ""
				self.city = ""
			} else {
				let address: GMSAddress? = results?.firstResult()
				
				if let locality = address?.locality {
					self.city = locality
				}
				if let countr = address?.country {
					self.country = countr
				}
				var arr:[String] = []
				if let arr1 = address?.lines {
					arr = arr1
				}
				
				let str1 = String(format: "%lu", UInt(arr.count))
				if (str1 == "0") {
					self.addressLabel.text = ""
				} else if (str1 == "1") {
					let str2 = arr[0]
					self.addressLabel.text = str2
				}else if (str1 == "2") {
					let str2 = arr[0]
					let str3 = arr[1]
					if (str2.count) > 1 {
						self.addressLabel.text = "\(str2),\(str3)"
					} else {
						self.addressLabel.text = "\(str3)"
					}
				}
			}
		})
	}
	
	@IBAction func setAddressButtonAction(_ sender: Any) {
		if (addressLabel.text?.count ?? 0) == 0 {
			return
		}
		address = addressLabel.text ?? ""
		lat = "\(googleMapView.camera.target.latitude)"
		lng = "\(googleMapView.camera.target.longitude)"
		performSegue(withIdentifier: "unwindFromLocationPickerView", sender: nil)
	}
	
	@IBAction func locateCurrentLocation(_ sender: Any) {
		let camera = GMSCameraPosition.camera(withLatitude: Double(lat) ?? 0.0, longitude: Double(lng) ?? 0.0, zoom: 16)
		googleMapView.camera = camera
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		country = ""
		city = ""
		dismiss(animated: true)
		if let formattedAddress = place.formattedAddress {
			print("Place address \(formattedAddress)")
		}
		selectedPlace = place
		let latitude = place.coordinate.latitude
		let longitude = place.coordinate.longitude
		let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
		googleMapView.camera = camera
		addressLabel.text = place.formattedAddress
		
		for compCity: GMSAddressComponent? in (place.addressComponents)! {
			if (compCity?.type == "locality") {
				if compCity?.name != nil  {
					city = compCity!.name
				}else{
					city = ""
				}
			} else if (compCity?.type == "country") {
				if compCity?.name != nil  {
					country = compCity!.name
				}else{
					country = ""
				}
			}
		}
	}
	
	// User canceled the operation.
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		dismiss(animated: true)
	}
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		print("Error: \(description)")
	}
}
