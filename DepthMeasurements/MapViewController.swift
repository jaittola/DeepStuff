//
//  MapViewController.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 09/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var depth: UITextField!
    @IBOutlet weak var currentPositionButton: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPanRegognizer: UIPanGestureRecognizer!

    var locationManager: CLLocationManager? = nil
    var locationInUse: Bool = false
    
    var currentMeasurement: Measurement? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.showsScale = true
        mapView.userTrackingMode = .follow

        mapPanRegognizer.delegate = self

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            mapView.addAnnotations(appDelegate.depths.values.map { (m: Measurement) in MeasurementMKAnnotation(m) } )
        }

        setupLocationManager()
        updateMeasurement()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        updateCurrentLocationTracking(isInUse: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentLocationClicked(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
        updateCurrentLocationTracking(isInUse: !locationInUse)
    }

    func updateCurrentLocationTracking(isInUse: Bool) {
        if (isInUse == locationInUse) {
            return
        }

        locationInUse = isInUse
        print("Updating location tracking. Location in use \(locationInUse)")
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
                mapView.addAnnotation(MeasurementMKAnnotation(measurement))
            }
        }
    }

    @IBAction func textfieldValueChanged(_ sender: UITextField) {
        updateMeasurement()
    }

    @IBAction func mapPanned(_ sender: UIPanGestureRecognizer) {
        print("Map panned, state \(sender.state)")
        if (sender.state == .ended) {
            updateCurrentLocationTracking(isInUse: false)
            view.endEditing(true)
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
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
            mapView.setCenter(location.coordinate, animated: true)
        } else {
            latitude.text = ""
            longitude.text = ""
        }
        updateMeasurement()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let v = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        v.markerTintColor = UIColor.red
        v.titleVisibility = .visible
        /*
        if let m = annotation as? Measurement {
            v.glyphText = String(m.depth)
        }
 */
        return v
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func updateMeasurement() {
        currentMeasurement = Measurement(latitude: latitude.text, longitude: longitude.text, depth: depth.text)
        saveButton?.isEnabled = currentMeasurement != nil
    }
}
