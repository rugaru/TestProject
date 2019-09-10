//
//  PlaceSelectionCoordinator.swift
//  TestProject
//
//  Created by alina.golubeva on 09/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift
import Swinject

class PlaceSelectionCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let container: Container
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    override func start() -> Observable<Void> {
        let viewModel = container.resolve(PlaceSelectionViewModelProtocol.self)!
        let viewController = container.resolve(PlaceSelectionViewController.self, argument: viewModel)!
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        viewModel.fromCity.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.showSearchCityCoordinator(rootViewController: viewController)
                .bind(to: viewModel.fromCitySubject)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        viewModel.toCity.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.showSearchCityCoordinator(rootViewController: viewController)
                .bind(to: viewModel.toCitySubject)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        viewModel.searchCity.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let places = [viewModel.fromCitySubject, viewModel.toCitySubject].map { subject -> Place in
                return try! subject.value()!
            }
            _ = self.showMap(navigationController: navigationController, places: places)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func showSearchCityCoordinator(rootViewController: UIViewController) -> Observable<Place> {
        let searchCityCoordinator = SearchPlaceCoordinator(rootViewController: rootViewController, container: container)
        return coordinate(to: searchCityCoordinator)
    }
    
    func showMap(navigationController: UINavigationController, places: [Place]) -> Observable<Void> {
        let mapCoordinator = MapCoordinator(navigationController: navigationController, container: container, places: places)
        return coordinate(to: mapCoordinator)
    }
}
