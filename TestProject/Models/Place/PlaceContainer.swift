//
//  PlaceContainer.swift
//  TestProject
//
//  Created by alina.golubeva on 09/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import Foundation

struct PlaceContainer: Codable {
    let response: Response?
}

// MARK: - Response
struct Response: Codable {
    let geoObjectCollection: GeoObjectCollection?
    
    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let featureMember: [FeatureMember]?
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject?
    
    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let geoObjectDescription, name: String?
    let point: Point?
    
    enum CodingKeys: String, CodingKey {
        case geoObjectDescription = "description"
        case name
        case point = "Point"
    }
}

// MARK: - Point
struct Point: Codable {
    let pos: String?
}
