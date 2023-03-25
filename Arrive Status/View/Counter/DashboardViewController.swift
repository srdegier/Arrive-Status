//
//  ViewController.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 02/03/2023.
//

import UIKit
import CoreLocation

class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var counterTitleLabel: UILabel!
    @IBOutlet weak var counterValueLabel: UILabel!
    
    lazy var locationManager = CLLocationManager()
    let counterViewModel = CounterViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(counterUpdated), name: NSNotification.Name ("counter.updated"), object: nil)
        
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
        
        self.updateView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name("com.user.login.success"), object: nil)
    }
    
    @objc public func counterUpdated() {
        self.updateView()
    }
    
    public func updateView() {
        self.counterViewModel.getCounter()
        
        self.counterTitleLabel.text = self.counterViewModel.title
        self.counterValueLabel.text = String(self.counterViewModel.value)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
