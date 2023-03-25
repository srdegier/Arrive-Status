//
//  ViewController.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 02/03/2023.
//

import UIKit
import CoreLocation

class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Dashboard"
        
        self.locationManager.requestAlwaysAuthorization()
        
        // Your coordinates go here (lat, lon)
        let geofenceRegionCenter = CLLocationCoordinate2D(
            latitude: 51.917516,
            longitude: 4.483971
        )
        
        /* Create a region centered on desired location,
         choose a radius for the region (in meters)
         choose a unique identifier for that region */
        let geofenceRegion = CLCircularRegion(
            center: geofenceRegionCenter,
            radius: 500,
            identifier: "School"
        )
        
        
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: geofenceRegion)
    
    }
    
    @IBAction func addDestinationButtonPressed(_ sender: Any) {
        print("!@Naar de nieuwe view")
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDestinationViewController") as! AddDestinationViewController
//                navigationController?.pushViewController(vc, animated: true)
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let maxDistance = locationManager.maximumRegionMonitoringDistance
            let region = CLCircularRegion(center: center,
                 radius: 100, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
       
            locationManager.startMonitoring(for: region)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
