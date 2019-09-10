//
//  SearchPlaceCoordinator.swift
//  TestProject
//
//  Created by alina.golubeva on 09/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift
import Swinject

class SearchPlaceCoordinator: BaseCoordinator<Place> {
    private let rootViewController: UIViewController
    private let container: Container
    
    init(rootViewController: UIViewController, container: Container) {
        self.rootViewController = rootViewController
        self.container = container
    }
    
    override func start() -> Observable<Place> {
        let viewModel = container.resolve(SearchPlaceViewModelProtocol.self)!
        let viewController = container.resolve(SearchPlaceViewController.self, argument: viewModel)!
        viewController.modalPresentationStyle = .overCurrentContext
        
        rootViewController.present(viewController, animated: true, completion: nil)
        
        return viewModel.selectedCity
            .asObservable()
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
