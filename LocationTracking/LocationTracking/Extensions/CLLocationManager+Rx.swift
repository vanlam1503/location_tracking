//
//  CLLocationManager+Rx.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import RxSwift
import CoreLocation
import RxCocoa

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

final class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {

    static func registerKnownImplementations() {}
}

extension Reactive where Base: CLLocationManager {

    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .compactMap { paramerters in
                return paramerters.last as? [CLLocation]
            }
    }
}
