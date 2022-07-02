//
//  LocationCache.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation

protocol Cache {
    func store<Value>(key: String, value: Value) where Value: Encodable
    func get<Value>(key: String) -> Value? where Value: Decodable
}

struct LocationCache: Cache {
    
    init() {
        
    }
    
    func store<Value>(key: String, value: Value) where Value: Encodable {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func get<Value>(key: String) -> Value? where Value: Decodable {
        if let data = UserDefaults.standard.value(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(Value.self, from: data) {
            return value
        }
        return nil
    }
}
