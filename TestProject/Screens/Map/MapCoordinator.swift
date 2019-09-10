//
//  MapCoordinator.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import UIKit

import RxSwift
import Swinject

class MapCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let container: Container
    private let places: [Place]
    init(navigationController: UINavigationController, container: Container, places: [Place]) {
        self.navigationController = navigationController
        self.container = container
        self.places = places
    }
    
    override func start() -> Observable<Void> {
        let viewModel = container.resolve(MapViewModelProtocol.self, argument: places)!
        let viewController = container.resolve(MapViewController.self, argument: viewModel)!
        
        navigationController.pushViewController(viewController, animated: true)
        
        return .never()
    }
}

