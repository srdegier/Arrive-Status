//
//  CounterRepository.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 25/03/2023.
//

import Foundation
import SQLite

class CounterRepository {
    
    private let sqliteDatabaseManager = SQLiteDatabaseManager.shared
    private var db: Connection
    
    let counter = Table("counter")
    let id = Expression<Int64>("id")
    let title = Expression<String>("title")
    let value = Expression<Int64>("value")
    
    init() {
        guard let db = sqliteDatabaseManager.db else {
            fatalError("No database connection found")
        }
        self.db = db
        self.createTable()
    }
    
    internal func createTable() -> Void {
        do {
            try self.db.run(counter.create { table in
                table.column(id, primaryKey: true)
                table.column(title)
                table.column(value, unique: true)
            })
            // create row for counter
            self.addCounter()
        } catch {
            print("!@Error creating table: \(error)")
        }
    }
    // doe hier nog de title meegeven
    internal func addCounter() {
        do {
            let rowid = try self.db.run(counter.insert(value <- 0, title <- "School"))
        } catch {
            print("!@insertion failed: \(error)")
        }
    }
    
    public func updateCounterValue(increment: Int64) {
        do {
            try db.run(counter.update(value <- increment))
        } catch {
            print("Error: \(error)")
        }
    }
    
    public func getCounter() -> Counter? {
        do {
            let titleExpression = Expression<String>("title")
            let valueExpression = Expression<Int>("value")
            if let counter = try db.pluck(counter.select(titleExpression, valueExpression)) {
                let title = counter[titleExpression]
                let value = counter[valueExpression]
                return Counter(title: title, value: value)
            } else {
                return nil // Counter-rij bestaat niet in de database
            }
        } catch {
            // Handel de fout hier af
            print("!@Error: \(error)")
            return nil
        }
    }

}
