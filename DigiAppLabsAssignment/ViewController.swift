//
//  ViewController.swift
//  DigiAppLabsAssignment
//
//  Created by Rajendra on 10/11/24.
//


import UIKit
import CoreLocation
import MapboxMaps

class ViewController: UIViewController {
    // Define a MapView object
    private var mapView: MapView!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization() // Request location permissions
               locationManager.startUpdatingLocation()
        
        
        // Initialize the MapView with options
        let mapInitOptions = MapInitOptions(resourceOptions: ResourceOptions(accessToken: "pk.eyJ1Ijoicm1haGljaGEiLCJhIjoiY20zYjM0M3YyMHZ1azJqc2FzNzloaWJ0dyJ9.F34u35Kd5GMYkWbUXr_Cbg"))
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        
        // Add the mapView to the main view
        view.addSubview(mapView)
        
        // Set up constraints to make the map view fill the screen
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Enable user location tracking
        mapView.location.options.puckType = .puck2D()
        mapView.location.options.activityType = .fitness  // Optional: Define the activity type for location accuracy
        mapView.location.options.desiredAccuracy = kCLLocationAccuracyBest

        // Request location permission
        mapView.location.delegate = self
        mapView.location.requestTemporaryFullAccuracyPermissions(withPurposeKey: "Location tracking for navigation")
//        mapView.location.requestLocationPermissions()
    }
}

extension ViewController: LocationPermissionsDelegate {
    func locationManagerDidChangeAuthorization(_ locationManager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
           locationManager.authorizationStatus == .authorizedAlways {
            mapView.location.options.puckType = .puck2D()
        } else {
            // Handle the case where permission is not granted
            print("Location permission not granted.")
        }
    }
}

extension ViewController: LocationConsumer {
    func locationUpdate(newLocation: Location) {
        let centerCoordinate = CLLocationCoordinate2D(
            latitude: newLocation.coordinate.latitude,
            longitude: newLocation.coordinate.longitude
        )
        mapView.mapboxMap.setCamera(to: CameraOptions(center: centerCoordinate, zoom: 14.0))
    }
}

//extension ViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            // Location access granted, proceed with showing the user's location on the map
//            locationManager.startUpdatingLocation()
//        case .denied, .restricted:
//            // Location access denied, handle accordingly (e.g., show an alert)
//            print("Location access denied or restricted")
//        case .notDetermined:
//            // Request authorization if the status is not determined
//            locationManager.requestWhenInUseAuthorization()
//        @unknown default:
//            break
//        }
//    }
//}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation() // Start updating location once authorized
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }

        // Center the map on the user's current location
        let userCoordinate = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        mapView.mapboxMap.setCamera(to: CameraOptions(center: userCoordinate, zoom: 14.0))
    }
}

