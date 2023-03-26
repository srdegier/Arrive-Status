//
//  ViewController.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 02/03/2023.
//

import UIKit
import CoreLocation
import CloudKit

class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var counterTitleLabel: UILabel!
    @IBOutlet weak var counterValueLabel: UILabel!
    
    @IBOutlet weak var internetConnectivityView: UIView!
    @IBOutlet weak var internetConnectivityLabel: UILabel!
    
    lazy var locationManager = CLLocationManager()
    let counterViewModel = CounterViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for when counter is updated
        NotificationCenter.default.addObserver(self, selector: #selector(counterUpdated), name: NSNotification.Name ("counter.updated"), object: nil)
        
        // Start monitoring for internet connectivity
        ConnectivityHelper.shared.startMonitoring()
        
        // Add observer for connectivityDidChange notification
        NotificationCenter.default.addObserver(self, selector: #selector(connectivityDidChange(_:)), name: .connectivityDidChange, object: nil)
        
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
            radius: 150,
            identifier: "School"
        )
        
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: geofenceRegion)
        
        self.updateView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ConnectivityHelper.shared.stopMonitoring()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name("counter.updated"), object: nil)
    }
    
    @objc public func counterUpdated() {
        self.updateView()
    }
    
    @objc func connectivityDidChange(_ notification: Notification) {
        let isConnected = notification.object as! Bool
        
        if isConnected {
            DispatchQueue.main.async {
                self.internetConnectivityView.isHidden = false
                self.internetConnectivityView.backgroundColor = .green
                self.internetConnectivityLabel.text = "Online"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.internetConnectivityView.isHidden = true
                }
            }
        } else {
            DispatchQueue.main.async {
                self.internetConnectivityView.isHidden = false
                self.internetConnectivityView.backgroundColor = .red
                self.internetConnectivityLabel.text = "Offline"
            }
        }
    }
    
    public func updateView() {
        self.counterViewModel.fetchCounter {
            self.counterTitleLabel.text = self.counterViewModel.title
            self.counterValueLabel.text = String(self.counterViewModel.value)
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
