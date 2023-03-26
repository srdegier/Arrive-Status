//
//  CounterViewModel.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 20/03/2023.
//

import Foundation

class CounterViewModel {
    
    // is een singeleton van gemaakt omdat de delegate en controller er samen gebruik van maken
    static let shared = CounterViewModel()
    
    var counter: Counter?
    let counterRepository = CounterRepository()
    let counterApi = CounterApi()
        
    // properties
    
    var title: String {
        return counter?.title ?? "Loading..."
    }

    var value: Int {
        return counter?.value ?? 0
    }
    
    var isSynced: Bool {
        return checkSynced()
    }
    
    var isInternetAvailable: Bool {
        return ConnectivityHelper.shared.isInternetAvailable()
    }
    
    // methods
    
    public func increaseCounter() {
        // oftewel hier de counter increasen
        self.fetchCounter() {
            let increment = self.value + 1
            let isSynced = self.isInternetAvailable
            // uncomment this for testing
            //let isSynced = false
            
            self.counterRepository.updateCounterValue(increment: Int64(increment), _isSynced: isSynced)
            
            // comment this out for testing offline
            if self.isInternetAvailable {
                self.counterApi.updateCounterValue(increment: increment) {
                    NotificationCenter.default.post(name:NSNotification.Name("counter.updated"), object: nil)
                }
            }

            NotificationCenter.default.post(name:NSNotification.Name("counter.updated"), object: nil)
        }
    }
    
    public func fetchCounter(completion: @escaping () -> Void) {
        if self.isInternetAvailable {
            // check if local record is in sync with Cloudkit
            if !self.isSynced {
                self.syncCounter() {
                    NotificationCenter.default.post(name:NSNotification.Name("counter.updated"), object: nil)
                }
            } else {
                self.counterApi.getCounter { counter in
                     if let counter = counter {
                         self.counter = counter
                     } else {
                         self.counter = self.counterRepository.getCounter()
                     }
                     DispatchQueue.main.async {
                         completion()
                     }
                 }
            }
        } else {
            self.counter = self.counterRepository.getCounter()
            completion()
        }
        // testing for offline
        
//        self.counter = self.counterRepository.getCounter()
//        completion()
     }
    
    private func syncCounter(completion: @escaping () -> Void) -> Void {
        // haal de lokale counter op
        let row = self.counterRepository.getCounter()
        // update middels de lokale counter data de cloudkit database
        self.counterApi.updateCounterValue(increment: row!.value) {
            self.counterRepository.updateCounterIsSynced()
            completion()
        }
    }
    
    func checkSynced() -> Bool {
        guard let counter = self.counterRepository.getCounter(), let isSynced = counter.isSynced else {
            return false
        }
        return isSynced
    }

}
