//
//  AppDelegate.swift
//  CustomLocationPicker
//
//  Created by Paa Quesi Afful on 03/03/2019.
//  Copyright © 2019 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import AVKit
import CoreLocation
import UIKit
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		// Override point for customization after application launch.
		
		GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
		GMSServices.provideAPIKey(GOOGLE_API_KEY)
		getCurrentLocation()
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//NSLog(@"didUpdateToLocation: %@",[locations lastObject]);
		currentLocation = locations.last
		if currentLocation != nil {
			CURRENT_LATITUDE = currentLocation!.coordinate.latitude
			CURRENT_LONGITUDE = currentLocation!.coordinate.longitude
			DispatchQueue.global(qos: .default).async(execute: {
				self.getAddressFrom(currentLocation)
			})
		}
	}
	
	func getCurrentLocation() {
		
		locationManager1 = CLLocationManager()
		locationManager1!.delegate = self
		locationManager1!.distanceFilter = kCLDistanceFilterNone
		locationManager1!.desiredAccuracy = kCLLocationAccuracyBest
		if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
			locationManager1!.requestWhenInUseAuthorization()
		}
		locationManager1!.startUpdatingLocation()
	}
	
	func getAddressFrom(_ location: CLLocation?) {
		if CURRENT_ADDRESS.isEmpty {
			return
		}
		//NSLog(@"getting address...");
		let req = "http://maps.googleapis.com/maps/api/geocode/json?latlng=\("\(location?.coordinate.latitude ?? 0)"),\("\(location?.coordinate.longitude ?? 0)")&output=csv"
		
		var result: String? = nil
		if let url = URL(string: req) {
			result = try? String(contentsOf: url, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
		}
		
		if result != nil {
			let data: Data? = result?.data(using: .utf8)
			var dictResponse: [AnyHashable : Any]? = nil
			if let data = data {
				dictResponse = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable : Any]
			}
			let resultArr = dictResponse?["results"] as? [Any] //objectForKey:@"geometry"];
			
			if (resultArr?.count ?? 0) > 0 {
				let dict = resultArr?[0] as? [AnyHashable : Any]
				if dict?["formatted_address"] != nil {
					DispatchQueue.main.sync(execute: {
						CURRENT_ADDRESS = dict?["formatted_address"] as! String
					})
				}
			}
		}
	}
}
