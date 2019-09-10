//
//  Path.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import Foundation

enum Path {
    case geocoder
    
    var url: String {
        switch self {
        case .geocoder: return "https://geocode-maps.yandex.ru/1.x/"
        }
    }
}
