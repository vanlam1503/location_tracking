//
//  HomeVC.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

final class HomeVC: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!

    private let viewModel: HomeViewModel
    private let bag = DisposeBag()
    private let trigger: PublishRelay<Void> = .init()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        binding()
        notify()
    }
    
    private func configView() {
        configNavigationView()
        configMapView()
    }
    
    private func configNavigationView() {
        title = App.Map.title
    }
    
    private func configMapView() {
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = false
    }
    
    private func binding() {
        let input = HomeViewModel.Input(trigger: trigger.asDriverOnEmpty())
        let output = viewModel.transform(input: input)
    
        output.requestAuthorization
            .drive()
            .disposed(by: bag)

        output.location
            .drive(onNext: { [weak self] location in
                self?.mapView.centerToLocation(CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng))
                self?.addAnnotation(location: location)
            })
            .disposed(by: bag)
        
        // Show all location stored in map view
        output.locations.filter { !$0.isEmpty }.drive(onNext: { [weak self] locations in
            self?.addAnnotations(locations: locations)
        }).disposed(by: bag)
    }
    
    private func addAnnotation(location: Location) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
        mapView.addAnnotation(annotation)
    }
    
    private func addAnnotations(locations: [Location]) {
        let annotations: [MKAnnotation] = locations.map { location -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    private func notify() {
        trigger.accept(())
    }
}
