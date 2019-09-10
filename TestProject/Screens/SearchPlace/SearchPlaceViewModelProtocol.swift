//
//  SearchPlaceViewModelProtocol.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift

protocol SearchPlaceViewModelProtocol {
    var places: Observable<[Place]> { get }
    var selectedCity: PublishSubject<Place> { get }
    
    func searchPlace(text: String)
}
