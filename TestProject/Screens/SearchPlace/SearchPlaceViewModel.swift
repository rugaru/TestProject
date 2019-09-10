//
//  SearchPlaceViewModel.swift
//  TestProject
//
//  Created by alina.golubeva on 09/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift

protocol SearchPlaceViewModelProtocol {
    var places: Observable<[Place]> { get }
    var selectedCity: PublishSubject<Place> { get }
    
    func searchPlace(text: String)
}

class SearchPlaceViewModel: SearchPlaceViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    var selectedCity: PublishSubject<Place>
    var places: Observable<[Place]>
    
    private let placesSubject = PublishSubject<[Place]>()
    
    private let searchCityService: SearchPlaceServiceProtocol
    
    init(searchCityService: SearchPlaceServiceProtocol) {
        self.searchCityService = searchCityService
        
        self.selectedCity = PublishSubject<Place>()
        self.places = placesSubject.asObservable()
    }
    
    func searchPlace(text: String) {
        searchCityService.searchPlace(text: text).subscribe(onSuccess: { [weak self] cities in
            guard let self = self else { return }
            self.placesSubject.onNext(cities)
        }).disposed(by: disposeBag)
    }
}
