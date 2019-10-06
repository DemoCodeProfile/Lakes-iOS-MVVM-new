//
//  MapLakesService.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MapLakesServiceProtocol {
    func configure(input: MapLakesService.Input) -> MapLakesService.Output
}

final class MapLakesService: MapLakesServiceProtocol {
    func configure(input: MapLakesService.Input) -> MapLakesService.Output { }
}

extension MapLakesService: Flowable {
    typealias Input = Void
    typealias Output = Void
}
