//
//  MapController.swift
//  FoodHub
//
//  Created by OPSolutions on 2/5/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class mapController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchBar: UIView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 500
    var previousLocation: CLLocation?
    var user = UserInfo()
    
    override func viewDidLoad() {
        
        mapSearchBar.layer.cornerRadius = 22
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationServices()
    }
    
    @IBAction func confirm(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            //Setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else{
            //Show alert letting the user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization(){
        
        switch locationManager.authorizationStatus {
    case .authorizedWhenInUse:
            // Do map Stuff
          startTrackingUserLocation()
        break
    case .denied:
            //Show alert instructing them how to turn on permissions
        break
    case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        break
    case .restricted:
            //Show an alert letting them know whats up
            break
    case .authorizedAlways:
        break
        @unknown default:
            print("Error")
        }
    }
    
    func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        user.latitude = latitude
        user.longitude = longitude
        return CLLocation(latitude: latitude, longitude: longitude)

    }
}

extension mapController: CLLocationManagerDelegate {
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//     //We'll be back here
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    //We'll be back
        checkLocationAuthorization()
    }
}

extension mapController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self ] (placemarks, error)
            in
        guard let self = self else { return }
        
        if let _ = error {
            ////TODO: Show alert informing the user
            return
        }
        guard let placemark = placemarks?.first else {
            //Todo: Show alert informing the user
            return
        }

            DispatchQueue.main.async {
                self.user.streetNumber = placemark.subThoroughfare ?? ""
                self.user.streetName = placemark.thoroughfare ?? ""
                self.user.postalCode = placemark.postalCode ?? ""
                self.user.district = placemark.administrativeArea ?? ""
                self.user.city = placemark.locality ?? ""
                
                self.addressLabel.text = ("\(self.user.streetNumber)\(self.user.streetName) \(self.user.postalCode) \(self.user.city) \(self.user.district)")
                print("This is your street name:\(self.user.streetName)")

            }
     }
    }
}
