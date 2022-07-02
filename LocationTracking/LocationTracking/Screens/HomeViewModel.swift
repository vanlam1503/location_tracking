//
//  HomeViewModel.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewModel: ViewModelType {
        
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let requestAuthorization: Driver<Void>
    }
    
    private let useCase: HomeUseCase
    private let bag = DisposeBag()
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let trigger = input.trigger
        let requestAuthorization = trigger.do(onNext: {
            useCase.requestAuthorization()
        })
        let didUpdateLocation = trigger.asObservable().flatMapLatest(useCase.didUpdateLocation)
        didUpdateLocation.asObservable().subscribe(onNext: { result in
            switch result {
            case .success(let location):
                print(location)
            case .failure(let error):
                print(error)
            }
        }).disposed(by: bag)
        
        return Output(
            requestAuthorization: requestAuthorization.asDriverOnEmpty()
        )
    }
}
