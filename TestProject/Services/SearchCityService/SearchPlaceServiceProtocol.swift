//
//  SearchPlaceServiceProtocol.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift

protocol SearchPlaceServiceProtocol {
    func searchPlace(text: String) -> Single<[Place]>
}
