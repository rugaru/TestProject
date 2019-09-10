//
//  AppDelegate.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()
    
    private let container: Container = {
        let container = Container()
        
        container.register(RequestProtocol.self, factory: { _ in
            Request()
        })
        
        container.register(SearchPlaceServiceProtocol.self, factory: { resolver in
            SearchPlaceService(request: resolver.resolve(RequestProtocol.self)!)
        })
        
        container.register(SearchPlaceViewModelProtocol.self, factory: { resolver in
            SearchPlaceViewModel(searchCityService: resolver.resolve(SearchPlaceServiceProtocol.self)! )
        })
        
        container.register(SearchPlaceViewController.self, factory: { resolver, viewModel in
            SearchPlaceViewController(viewModel: viewModel)
        })
        
        container.register(PlaceSelectionViewModelProtocol.self, factory: { _ in
            PlaceSelectionViewModel()
        })
        
        container.register(PlaceSelectionViewController.self, factory: { resolver, viewModel in
            PlaceSelectionViewController(viewModel: viewModel)
        })
        
        container.register(MapViewModelProtocol.self, factory: { _, places in
            MapViewModel(places: places)
        })
        
        container.register(MapViewController.self, factory: { resolver, viewModel in
            MapViewController(viewModel: viewModel)
        })
        
        return container
    }()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!, container: container)
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        return true
    }
}

