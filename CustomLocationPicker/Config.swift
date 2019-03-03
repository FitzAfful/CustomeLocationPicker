//
//  Config.swift
//  CustomLocationPicker
//
//  Created by Paa Quesi Afful on 02/03/2019.

import Foundation
import CoreLocation
import UIKit
import Foundation

let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate

let AppName = "Cleanline"
let GOOGLE_API_KEY = "AIzaSyCE3qWJOtYAQM5x9erHRnRN1srNkBmi3xg"
let REVERSE_GEOCODE_ADDRESS_NOTIFICATION = "REVERSE_GEOCODE_ADDRESS_NOTIFICATION"
let GEOCODE_ADDRESS_NOTIFICATION = "GEOCODE_ADDRESS_NOTIFICATION"
let APP_DELEGATE = UIApplication.shared.delegate as? AppDelegate
let PLACEHOLDER_COLOR = UIColor.white
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == .phone
let IS_RETINA = UIScreen.main.scale >= 2.0
let IS_HEIGHT_GTE_780 = UIScreen.main.bounds.size.height >= 780.0

let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let NAV_BAR_HEIGHT = 64.0

let ApplicationThemePatternImage = UIImage(named: "bg_pattern_image.png")
let ApplicationThemeColor = UIColor(red: 242 / 255.0, green: 0 / 255.0, blue: 48 / 255.0, alpha: 1.0)
let TextFieldInputColor = UIColor(red: 1 / 255.0, green: 86 / 255.0, blue: 166 / 255.0, alpha: 1.0)
enum RegistrationErrorDomain : Int {
	case registrationInvalidCountry
	case registrationInvalidPhone
	case registrationInvalidEmail
	case registrationInvalidPassword
	case registrationInvalidConfirmPassword
	case registrationUnknownError
	case registrationInvalidTerms
}

var CURRENT_LATITUDE: Double = 0.0
var CURRENT_LONGITUDE: Double = 0.0
var CURRENT_ADDRESS = ""
var locationManager1: CLLocationManager?
var currentLocation: CLLocation?
