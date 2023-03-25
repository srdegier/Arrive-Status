//
//  CounterViewModel.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 20/03/2023.
//

import Foundation

class CounterViewModel {
    
    let counter: Counter?
    
    init(counter: Counter = Counter()) {
        self.counter = counter
    }
    
    var title: String {
        return counter?.title ?? ""
    }

    var value: Int {
        return counter?.value ?? 0
    }
    
    // methods
    
    public func printMessage() {
        // oftewel hier de counter increasen
        print("!@", self.title)
        print("!@Gebruiker is in de geofence gekomen!")
    }
    
}
