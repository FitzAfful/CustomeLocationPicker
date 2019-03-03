//
//  ViewController.swift
//  CustomLocationPicker
//
//  Created by Paa Quesi Afful on 02/03/2019.
//  Copyright © 2019 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController {
	@IBOutlet weak var labelLat: UILabel!
	@IBOutlet weak var labelLng: UILabel!
	@IBOutlet weak var labelAddressName: UILabel!
	@IBOutlet weak var labelFormattedAddress: UILabel!
	
	@IBAction func selectAddressAction(_ sender: Any) {
		performSegue(withIdentifier: "VIEW_TO_ADDRESS_PICKER", sender: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.destination is CustomLocationPickerVC) {
			let vc = segue.destination as? CustomLocationPickerVC
			vc?.lat = "\(CURRENT_LATITUDE)" != "" ? "\(CURRENT_LATITUDE)" : ""
			vc?.lng = "\(CURRENT_LONGITUDE)" != "" ? "\(CURRENT_LONGITUDE)" : ""
			if(!CURRENT_ADDRESS.isEmpty){
				vc?.address = CURRENT_ADDRESS 
			}else{
				vc?.address = ""
			}
		}
	}
	
	@IBAction func unwindFromLocationPicker(toCreateOrder segue: UIStoryboardSegue) {
		if (segue.source is CustomLocationPickerVC) {
			//        ProfileCell *cell = (ProfileCell*)[self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
			let vc = segue.source as? CustomLocationPickerVC
			if let lat = vc?.lat {
				labelLat.text = "LAT - \(lat)"
			}
			if let lng = vc?.lng {
				labelLng.text = "LNG - \(lng)"
			}
			if let address = vc?.address {
				labelFormattedAddress.text = "ADDRESS - \(address)"
			}
			if let city = vc?.city, let country = vc?.country {
				labelAddressName.text = "CITY - \(city), COUNTRY - \(country)"
			}
		}
	}
}
