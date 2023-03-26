//
//  CounterApi.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 26/03/2023.
//

import Foundation
import CloudKit

class CounterApi {
    
    /// The CloudKit container to use. Update with your own container identifier.
    private let container = CKContainer(identifier: "iCloud.ArriveStatus")

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var privateDatabase = container.privateCloudDatabase
    
    public func getCounter(completion: @escaping (Counter?) -> Void) {
        let query = CKQuery(recordType: "Counter", predicate: NSPredicate(value: true))
        privateDatabase.fetch(withQuery: query, resultsLimit: 1) { (result) in
            switch result {
            case .success((let matchResults, _)):
                for (_, recordResult) in matchResults {
                    switch recordResult {
                    case .success(let record):
                        let counter = Counter(title: record["title"] as! String, value: record["value"] as! Int)
                        completion(counter)
                    case .failure(let error):
                        print("Failed to fetch record with error: \(error)")
                    }
                }
            case .failure(_):
                print("!@Error")
                completion(nil)
            }
        }
    }
    
    public func updateCounterValue(increment: Int, completion: @escaping () -> Void) {
        let recordID = CKRecord.ID(recordName: "B0E98098-D2C1-58DC-83C7-669249B1472F")
        let record = CKRecord(recordType: "Counter", recordID: recordID)
    
        // Fetch the record
        self.privateDatabase.fetch(withRecordID: recordID) { (fetchedRecord, error) in
            if let error = error {
                print("!@Error fetching record: \(error.localizedDescription)")
                return
            }
            
            guard let record = fetchedRecord else {
                print("!@Record not found")
                return
            }
            
            // Update the record
            record["value"] = increment as CKRecordValue
            
            // Save the updated record
            self.privateDatabase.save(record) { (savedRecord, error) in
                if let error = error {
                    print("!@Error saving record: \(error.localizedDescription)")
                    return
                }
                
                guard let record = savedRecord else {
                    print("!@Record not saved")
                    return
                }
                
                print("!@Record updated: \(record)")
                completion()
            }
        }

    }

}
