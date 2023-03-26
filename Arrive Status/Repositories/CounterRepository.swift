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
    let isSynced = Expression<Bool>("isSynced")
    
    init() {
        guard let db = sqliteDatabaseManager.db else {
            fatalError("No database connection found")
        }
        self.db = db
        print("!@init")
        self.createTable()
    }
    
    internal func createTable() -> Void {
        do {
            try self.db.run(counter.create { table in
                table.column(id, primaryKey: true)
                table.column(title)
                table.column(value, unique: true)
                table.column(isSynced, unique: true)
            })
            // create row for counter
            self.addCounter()
        } catch {
            print("!@Error creating table: \(error)")
        }
    }
    // doe hier nog de title meegeven
    internal func addCounter() {
        print ("!@ nieuwe counter")
        do {
            let rowid = try self.db.run(counter.insert(value <- 0, title <- "School", isSynced <- true))
        } catch {
            print("!@insertion failed: \(error)")
        }
    }
    
    public func updateCounterValue(increment: Int64, _isSynced: Bool) {
        do {
            try db.run(counter.update(value <- increment, isSynced <- _isSynced))
        } catch {
            print("Error: \(error)")
        }
    }
    
    public func updateCounterIsSynced() {
        do {
            try db.run(counter.update(isSynced <- true))
        } catch {
            print("Error: \(error)")
        }
    }
    
    public func getCounter() -> Counter? {
        do {
            let titleExpression = Expression<String>("title")
            let valueExpression = Expression<Int>("value")
            let isSyncedExpression = Expression<Bool>("isSynced")
            if let counter = try db.pluck(counter.select(titleExpression, valueExpression, isSyncedExpression)) {
                let title = counter[titleExpression]
                let value = counter[valueExpression]
                let isSynced = counter[isSyncedExpression]
                return Counter(title: title, value: value, isSynced: isSynced)
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
