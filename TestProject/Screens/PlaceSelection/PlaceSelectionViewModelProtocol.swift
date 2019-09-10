//
//  PlaceSelectionViewModelProtocol.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift

protocol PlaceSelectionViewModelProtocol {
    var fromCity: Observable<Void> { get }
    var fromCityObserver: AnyObserver<Void> { get }
    var fromCitySubject: BehaviorSubject<Place?> { get }
    
    var toCity: Observable<Void> { get }
    var toCityObserver: AnyObserver<Void> { get }
    var toCitySubject: BehaviorSubject<Place?> { get }
    
    var searchCityObserver: AnyObserver<Void> { get }
    var searchCity: Observable<Void> { get }
}
