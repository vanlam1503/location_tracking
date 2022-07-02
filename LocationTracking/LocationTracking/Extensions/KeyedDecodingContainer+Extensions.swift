//
//  KeyedDecodingContainer+Extensions.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation

infix operator <-: AssignmentPrecedence

func <-<T: Decodable>(lhs: inout T?, rhs: T) {
    lhs = rhs
}

func <-<T: Decodable>(lhs: inout T, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}

public extension KeyedDecodingContainer where K: CodingKey {

    subscript<T: Decodable>(key: K) -> T? {
        try? decodeIfPresent(T.self, forKey: key)
    }

    subscript<T: RawRepresentable>(key: K) -> T? where T.RawValue: Decodable {
        if let rawValue = try? decodeIfPresent(T.RawValue.self, forKey: key) {
            return T(rawValue: rawValue)
        }
        return nil
    }
}
