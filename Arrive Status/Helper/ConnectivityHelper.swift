//
//  ConnectivityHelper.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 25/03/2023.
//

import Foundation
import Network

import Foundation
import Network

class ConnectivityHelper {
    
    static let shared = ConnectivityHelper()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityMonitor")
    private var isConnected = false
    
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.postConnectivityDidChangeNotification()
        }
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    public func isInternetAvailable() -> Bool {
        let path = monitor.currentPath
        return path.status == .satisfied
    }
    
    private func postConnectivityDidChangeNotification() {
        NotificationCenter.default.post(name: .connectivityDidChange, object: isConnected)
    }
}

extension NSNotification.Name {
    static let connectivityDidChange = Notification.Name("ConnectivityDidChangeNotification")
}


