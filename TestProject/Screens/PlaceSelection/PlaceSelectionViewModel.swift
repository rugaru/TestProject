//
//  PlaceSelectionViewModel.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
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

class PlaceSelectionViewModel: PlaceSelectionViewModelProtocol {
    var fromCityObserver: AnyObserver<Void>
    var fromCity: Observable<Void>
    var fromCitySubject: BehaviorSubject<Place?>
    
    var toCityObserver: AnyObserver<Void>
    var toCity: Observable<Void>
    var toCitySubject: BehaviorSubject<Place?>
    
    var searchCityObserver: AnyObserver<Void>
    var searchCity: Observable<Void>
    
    init() {
        let _fromCity = PublishSubject<Void>()
        self.fromCity = _fromCity.asObservable()
        self.fromCityObserver = _fromCity.asObserver()
        
        fromCitySubject = BehaviorSubject<Place?>(value: nil)
        
        let _toCity = PublishSubject<Void>()
        self.toCity = _toCity.asObservable()
        self.toCityObserver = _toCity.asObserver()
        
        toCitySubject = BehaviorSubject<Place?>(value: nil)
        
        let _searchCity = PublishSubject<Void>()
        self.searchCityObserver = _searchCity.asObserver()
        self.searchCity = _searchCity.asObservable()
    }
}
