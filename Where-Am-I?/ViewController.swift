//
//  ViewController.swift
//  Where-Am-I?
//
//  Created by Lala Vaishno De on 5/21/15.
//  Copyright (c) 2015 Lala Vaishno De. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //println(locations)
        
        var userLocation: CLLocation = locations[0] as CLLocation
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var course = userLocation.course
        var speed = userLocation.speed
        var altitude = userLocation.altitude
        
        latitudeLabel.text = "\(latitude)"
        longitudeLabel.text = "\(longitude)"
        courseLabel.text = "\(course)"
        speedLabel.text = "\(speed)"
        altitudeLabel.text  = "\(altitude)"
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
            //println(location)
            
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                println(pm.thoroughfare)
                println(pm.subThoroughfare)
                

                var subThoroughfare = pm.subThoroughfare ?? ""
                var thoroughfare = pm.thoroughfare ?? ""
                var gayfare = subThoroughfare + " " + thoroughfare
                var locality = pm.locality ?? ""
                var sublocality = pm.subLocality ?? ""
                var gaylocality = sublocality + " " + locality
                var adarea = pm.administrativeArea ?? ""
                var postal = pm.postalCode ?? ""
                var country = pm.country ?? ""
                var gaycomplete = adarea + " " + postal + " " + country
                
                
                var address = gayfare + " " + gaylocality + " " + gaycomplete
                self.currentLocationLabel.text = address
                
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
        
        
        var letDelta:CLLocationDegrees = 0.0001
        var lonDelta:CLLocationDegrees = 0.0001
        var span:MKCoordinateSpan = MKCoordinateSpanMake(letDelta, lonDelta)
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

