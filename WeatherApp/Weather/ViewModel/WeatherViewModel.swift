//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Cheng Guo on 2023/3/8.
//

import Foundation
import RxSwift
import RxCocoa
class WeatherViewModel {
    struct Input {
        var city: Observable<CityModel>
    }
    
    struct Output {
        var weather: Observable<WeatherModelResponse>
    }
    
    func transform(input: Input) -> Output {
        // transform the input sequence to weather response sequence, materialize the result to make sure the sequence won't be terminated due to an error
        let weatherResponseEvents = input.city.flatMap { city in
            weatherProvider.rx.request(.getWeather(longitude: city.longitude, latitude: city.latitude, unit: .metric)).asObservable().materialize()
        }
        let weatherEvents = weatherResponseEvents.elements().map(WeatherModelResponse.self)
        return Output(weather: weatherEvents)
    }
}
