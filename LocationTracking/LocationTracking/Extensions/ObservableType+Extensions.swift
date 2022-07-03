//
//  ObservableType+Extensions.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/3/22.
//

import UIKit
import RxSwift
import RxCocoa

extension ObservableType {

    func onSuccess<Value, Error>() -> Observable<Value> where Element == Result<Value, Error> {
        return self.compactMap { result in
            if case .success(let value) = result {
                return value
            }
            return nil
        }
    }

    func onFailure<Value, Error>() -> Observable<Error> where Element == Result<Value, Error> {
        return compactMap { result in
            if case .failure(let error) = result {
                return error
            }
            return nil
        }
    }
}
