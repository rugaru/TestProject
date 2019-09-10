//
//  AppCoordinator.swift
//  TestProject
//
//  Created by alina.golubeva on 09/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift
import Swinject

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let container: Container
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    override func start() -> Observable<Void> {
        let citySelectionCoordinator = PlaceSelectionCoordinator(window: window, container: container)
        return coordinate(to: citySelectionCoordinator)
    }
}
