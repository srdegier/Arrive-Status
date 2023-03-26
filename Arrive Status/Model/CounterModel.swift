//
//  CounterModel.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 20/03/2023.
//

import Foundation

struct Counter {
    
    let title: String
    let value: Int
    let isSynced: Bool?
    
    init(title: String, value: Int, isSynced: Bool? = nil) {
        self.title = title
        self.value = value
        self.isSynced = isSynced
    }

}

