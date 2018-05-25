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
    @IBOutlet weak var calculateRouteButton: UIBarButtonItem!
    @IBOutlet weak var instructionsButton: UIBarButtonItem!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var farms = [Farm]()
    var locationArray = [MKMapItem]()
    var steps = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
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
                    if let error = error {
                        print(error)
                    } else {
                        if let res = response {
                            for local in res.mapItems {
                                self.locationArray.append(local)
                                
                                let placemark = FarmAnnotation(title: farm.name,
                                                               subtitle: "Production: \(farm.gallons) Gallons - Pickup time: \(Farm.produceHourFormatter.string(from: farm.produceHour))",
                                    coordinate: local.placemark.coordinate)
                                
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
    

    @IBAction func calculateRouteButtonPress(_ sender: UIBarButtonItem) {
        for i in 0..<locationArray.count {
            if i + 1 < locationArray.count {
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = locationArray[i]
                directionRequest.destination = locationArray[i + 1]
                
                directionRequest.transportType = .automobile
                
                // Calculate the direction
                let directions = MKDirections(request: directionRequest)
                
                directions.calculate {
                    (response, error) in
                    if error != nil {
                        print("Error getting directions")
                    } else {
                        self.showRoute(response!)
                    }
                }
            }
        }
    }
    
    func showRoute(_ response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            mapView.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
            if route.steps.count > 0 {
                self.instructionsButton.isEnabled = true
                for step in route.steps {
                    steps.append(step.instructions)
                }
            } else {
                self.instructionsButton.isEnabled = false
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
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

extension RouteViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? FarmAnnotation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        super.prepare(for: segue, sender: sender)
        if segue.identifier == "routeInstructionsSegue" {
            let routeInstructionsViewController = segue.destination as! RouteInstructionsViewController
            routeInstructionsViewController.steps = self.steps
        }
    }
    
    @IBAction func unwindFromInstructions( segue: UIStoryboardSegue) {
        //
    }
}

