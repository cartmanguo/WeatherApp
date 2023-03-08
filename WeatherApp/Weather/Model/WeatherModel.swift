//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Cheng Guo on 2023/3/8.
//

import Foundation
/// Temperature Object Model
struct WeatherModel: Codable {
    enum WeatherModelKeys: String, CodingKey {
        case temp
    }
    var temp: Double
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherModelKeys.self)
        self.temp = try container.decode(Double.self, forKey: .temp)
    }
}

/// Weather Response JSON Model
struct WeatherModelResponse: Codable {
    enum WeatherModelResponseKeys: String, CodingKey {
        // I just need the temperature data, so I ignore the values which won't be used
        case main
    }
    var weather: WeatherModel
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherModelResponseKeys.self)
        self.weather = try container.decode(WeatherModel.self, forKey: .main)
    }
}
