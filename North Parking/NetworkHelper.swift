//
//  NetworkHelper.swift
//  North Parking
//
//  Created by Toby Kreiman on 9/28/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import FirebaseDatabase

class NetworkHelper {
    static let instance = NetworkHelper()
    
    var ref = Database.database().reference()
    
    
    func getSpotsFromServer(location: ParkingLocation, completion: @escaping (Int) -> Void) {
        ref.child("SpotsTaken").observeSingleEvent(of: .value) { (snapshot) in
            if let v = snapshot.value as? NSDictionary {
                if let n = v[location.rawValue] as? Int {
                    completion(n)
                } else {
                    completion(0)
                }
            }
        }
    }
    
    func updateSpots(location: ParkingLocation, completion: @escaping(Error?) -> Void) {
        ref.child("SpotsTaken").runTransactionBlock({ (data) -> TransactionResult in
            if var v = data.value as? [String: AnyObject] {
                let spots = v[location.rawValue] as! Int
                v[location.rawValue] = spots + 1 as AnyObject
                
                data.value = v
                return TransactionResult.success(withValue: data)
            }
            return TransactionResult.success(withValue: data)
        }) { (error, b, snapshot) in
            completion(error)
        }
    }
}
