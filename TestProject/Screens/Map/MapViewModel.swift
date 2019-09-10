//
//  MapViewModel.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import MapKit

class MapViewModel: MapViewModelProtocol {
    private let scale: Double = 1000000
    var coordinates: [Location]
    private var places: [Place]
    
    init(places: [Place]) {
        self.places = places
        self.coordinates = places.map({ Location(coordinate: $0.coordinates) })
    }
    
    func moveStep() -> Int {
        guard let fromPoint = coordinates.first?.toCLLocation(),
            let toPoint = coordinates.last?.toCLLocation() else { return 5 }
        let speed = Int(fromPoint.distance(from: toPoint) / scale)
        return speed == 0 ? 1 : speed
    }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(radians: atan2(y, x)).truncatingRemainder(dividingBy: 360)  + 90
    }
}
