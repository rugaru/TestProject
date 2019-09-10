//
//  MapViewModel.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import CoreLocation

protocol MapViewModelProtocol {
    var coordinates: [Location] { get }
}

class MapViewModel: MapViewModelProtocol {
    var coordinates: [Location]
    private var places: [Place]
    
    init(places: [Place]) {
        self.places = places
        self.coordinates = places.map({ Location(coordinate: $0.coordinates) })
    }
}
