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
        
    // properties
    
    var title: String {
        return counter?.title ?? ""
    }

    var value: Int {
        return counter?.value ?? 0
    }
    
    // methods
    
    public func increaseCounter() {
        // oftewel hier de counter increasen
        let increment = self.value + 1
        self.counterRepository.updateCounterValue(increment: Int64(increment))
        NotificationCenter.default.post(name:NSNotification.Name("counter.updated"), object: nil)
    }
    
    public func getCounter() {
        self.counter = self.counterRepository.getCounter()
    }
    
}
