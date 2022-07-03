//
//  NSManagedObject+Extensions.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/3/22.
//

import CoreData

extension NSManagedObject {
    
    subscript<T>(key: String) -> T? {
        set {
            setValue(newValue, forKey: key)
        }
        get {
            self.value(forKey: key) as? T
        }
    }
}
