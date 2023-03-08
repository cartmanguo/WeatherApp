//
//  Date+String.swift
//  WeatherApp
//
//  Created by Cheng Guo on 2023/3/8.
//

import Foundation
extension Date {
    func dateString(format: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
