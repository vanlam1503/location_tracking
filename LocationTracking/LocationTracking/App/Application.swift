//
//  Application.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import UIKit

struct Application {
    
    static let shared = Application()
    private let useCaseProvider: UseCaseProvider
    
    private init() {
        useCaseProvider = DefaultUseCaseProvider(
            locationManager: .shared,
            storage: .shared)
    }
    
    func configure(in window: UIWindow?) {
        let navi = UINavigationController()
        let useCase = useCaseProvider.makeHomeUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        let vc = HomeVC(viewModel: viewModel)
        navi.setViewControllers([vc], animated: false)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
    }
}
