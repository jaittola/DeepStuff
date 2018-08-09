//
//  ViewController.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 09/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var depth: UITextField!
    @IBOutlet weak var currentPositionButton: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var locationManager: CLLocationManager? = nil
    var locationInUse: Bool = false
    
    var currentMeasurement: Measurement? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupLocationManager()
        updateMeasurement()
    }
    
    func setupLocationManager() {
        locationInUse = false
        currentPositionButton.isHighlighted = false
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentLocationClicked(_ sender: UITapGestureRecognizer) {
        locationInUse = !locationInUse
        print("current location clicked. Location in use \(locationInUse)")
        if locationInUse {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
                currentPositionButton.isHighlighted = true
            case .restricted, .denied:
                // Disable location features
                print("Location services denied")
                locationInUse = false
                currentPositionButton.isHighlighted = false
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
                print("Authorized for location")
                locationManager?.startUpdatingLocation()
                currentPositionButton.isHighlighted = true
            }
        } else {
            locationManager?.stopUpdatingLocation()
            currentPositionButton.isHighlighted = false
        }
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let measurement = currentMeasurement {
                appDelegate.depths.add(measurement)
            }
        }
    }

    @IBAction func textfieldValueChanged(_ sender: UITextField) {
        updateMeasurement()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            // Disable location features
            print("Location services denied")
            locationInUse = false
            currentPositionButton.isHighlighted = false
        default:
            print("Location manager authorisation status \(status)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Getting location information failed: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude.text = String(location.coordinate.latitude)
            longitude.text = String(location.coordinate.longitude)
        } else {
            latitude.text = ""
            longitude.text = ""
        }
        updateMeasurement()
    }

    func updateMeasurement() {
        currentMeasurement = Measurement(latitude: latitude.text, longitude: longitude.text, depth: depth.text)
        saveButton?.isEnabled = currentMeasurement != nil
    }
}
