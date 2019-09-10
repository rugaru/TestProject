//
//  SearchPlaceService.swift
//  TestProject
//
//  Created by alina.golubeva on 09/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import RxAlamofire
import CodableAlamofire
import CoreLocation

protocol SearchPlaceServiceProtocol {
    func searchPlace(text: String) -> Single<[Place]>
}

class SearchPlaceService: SearchPlaceServiceProtocol {
    private let request: RequestProtocol
    
    init(request: RequestProtocol) {
        self.request = request
    }
    
    func searchPlace(text: String) -> Single<[Place]> {
        let parameters: [String : Any] = [
            "format": "json",
            "geocode": text
        ]

        let citiesRequest: Single<PlaceContainer> = request.makeRxGetRequest(path: .geocoder, parameters: parameters)
        return citiesRequest.map({ [weak self] container in
            guard let self = self else { return [] }
            return self.convertToCity(container: container)
        })
    }
    
    private func convertToCity(container: PlaceContainer) -> [Place] {
        guard let featureMember = container.response?.geoObjectCollection?.featureMember else { return [] }
        let places = featureMember.map { featureMember -> Place in
            guard let point = featureMember.geoObject?.point?.pos,
                let country = featureMember.geoObject?.geoObjectDescription,
                let name = featureMember.geoObject?.name
                else { return Place(name: "", country: "", coordinates: CLLocationCoordinate2D()) }
            return Place(name: name, country: country, coordinates: toCoordinate(coordinate: point))
        }
        return places
    }
    
    private func toCoordinate(coordinate: String) -> CLLocationCoordinate2D {
        let coordinates = coordinate.split(separator: " ").map(Double.init)
        guard let longitude = coordinates.first, let latitude = coordinates.last else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
}
