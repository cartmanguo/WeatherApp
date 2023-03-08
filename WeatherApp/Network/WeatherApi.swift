//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Cheng Guo on 2023/3/8.
//

import Foundation
import Moya
let OPEN_WEATHER_API_KEY = "ccbf337c4263ca76d5e7ea8c0cdc19b3"
/// The unit of temperature
enum WeatherTempUnit: String {
    /// Kelvins
    case standard = "standard"
    /// Celsius
    case metric = "metric"
    /// Fahrenheit
    case imperial = "imperial"
}

enum WeatherService {
    case getWeather(longitude: Double, latitude: Double, unit: WeatherTempUnit)
}

extension WeatherService: TargetType{
    var path: String {
        switch self {
        case .getWeather(_, _, _):
            return "weather"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeather(_, _, _):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getWeather(let longtitude, let latitude, let unit):
            return .requestParameters(parameters: ["lat": latitude, "lon": longtitude, "units": unit.rawValue, "appid": OPEN_WEATHER_API_KEY], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let headers = ["Content-Type": "application/json"]
        return headers
    }
    
    var baseURL: URL {
        switch self {
        case .getWeather(_, _, _):
            return URL(string: "https://api.openweathermap.org/data/2.5")!
        }
    }
}

let weatherProvider = MoyaProvider<WeatherService>()
