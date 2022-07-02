//
//  ObservableConvertibleType+Extensions.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {

    func asDriverOnEmpty() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
}

