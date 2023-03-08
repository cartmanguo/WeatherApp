//
//  Observable+Materialize.swift
//  WeatherApp
//
//  Created by Cheng Guo on 2023/3/8.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element: EventConvertible {
    public func elements() -> Observable<Element.Element> {
        return compactMap { $0.event.element }
    }
    
    public func errors() -> Observable<Swift.Error> {
        return compactMap { $0.event.error }
    }
}
