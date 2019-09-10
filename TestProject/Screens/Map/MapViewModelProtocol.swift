//
//  MapViewModelProtocol.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import MapKit

protocol MapViewModelProtocol {
    var coordinates: [Location] { get }
    func moveStep() -> Int
    func radiansToDegrees(radians: Double) -> Double
    func degreesToRadians(degrees: Double) -> Double
    func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection
}
