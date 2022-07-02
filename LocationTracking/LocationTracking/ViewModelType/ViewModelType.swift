//
//  ViewModelType.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
