//
//  RouteViewController.swift
//  MilkyWay
//
//  Created by Zanetti, Rafael on 24/05/18.
//  Copyright © 2018 Zanetti, Rafael. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var farms = [Farm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        if let savedFarms = Farm.loadFarms() {
            farms = savedFarms
        } else {
            farms = Farm.loadSampleFarms()
        }
        let queue = OperationQueue()
        
        for farm in farms {
            queue.addOperation {
                let request = MKLocalSearchRequest()
                request.naturalLanguageQuery = farm.address
                request.region = self.mapView.region
                
                let search = MKLocalSearch(request: request)
                
                search.start {
                    (response, error) in
                    if error == nil {
                        if let res = response {
                            for local in res.mapItems {
                                let placemark = FarmAnnotation(title: farm.name, coordinate: local.placemark.coordinate)
                                self.mapView.addAnnotation(placemark)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, self.mapView.region.span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        centerMapOnLocation(location: locations.first!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
