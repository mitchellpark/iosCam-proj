//
//  mapVC.swift
//  appThree
//
//  Created by Mitchell Park on 2/13/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapVC: UIViewController {

    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var progress: UIProgressView = {
        let p = UIProgressView()
        p.progressTintColor = .purple
        p.backgroundColor = .yellow
        p.setProgress(0.5, animated: true)
        return p
    }()
    var activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.hidesWhenStopped = false
        a.color = .purple
        a.backgroundColor = .yellow
       return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureLocationManager()
        DispatchQueue.main.async {
            self.view.addSubview(self.progress)
            self.progress.frame = CGRect(x: self.view.frame.minX+200, y: self.view.frame.minY+300, width: 100, height: 100)
            self.view.addSubview(self.activity)
            self.activity.frame = CGRect(x: self.view.frame.width+50, y: self.view.frame.height+200, width: 100, height: 100)
        }
    }
    
    func configureMapView(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    func configureLocationManager(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            setUpLocation()
        }else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    func setUpLocation(){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func setZoomRegion(to coordinate: CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(zoomRegion, animated: true)
    }

}
extension mapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Updated.")
        guard let latestLocation = locations.first else {return}
        if currentLocation == nil{
            setZoomRegion(to: latestLocation.coordinate)
        }
        currentLocation = latestLocation.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Auth changed.")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            setUpLocation()
        }
    }
}
