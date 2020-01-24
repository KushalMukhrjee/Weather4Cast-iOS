//
//  Forecast.swift
//  Weather4Cast
//
//  Created by Kushal on 03/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    
    var weatherList: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case weatherList = "list"
    }
    
}
