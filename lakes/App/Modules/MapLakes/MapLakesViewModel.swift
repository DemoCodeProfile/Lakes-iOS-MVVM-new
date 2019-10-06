//
//  MapLakesViewModel.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MapLakesViewModelProtocol {
    func configure(input: MapLakesViewModel.Input) -> MapLakesViewModel.Output
}

final class MapLakesViewModel: MapLakesViewModelProtocol {
    
    private let provider: MapLakesProviderProtocol
    private let service: MapLakesServiceProtocol

    init(service: MapLakesServiceProtocol, provider: MapLakesProviderProtocol) {
        self.service = service
        self.provider = provider
    }
    
    func configure(input: MapLakesViewModel.Input) -> MapLakesViewModel.Output {
        let inputProvider = MapLakesProvider.Input(receiveLakes: input.receiveLakes.asObservable())
        let outputProvider = provider.configure(input: inputProvider)
        let receivedLakesData = outputProvider.receivedLakes
            .map { $0.value?.map { MapLakeData(id: $0.id, title: $0.title, lat: $0.lat, lon: $0.lon) } }
            .filterNil()
            .asDriver(onErrorJustReturn: [])
        let error = outputProvider.receivedLakes
            .map { $0.error?.description }
            .filterNil()
            .asDriver(onErrorJustReturn: "")
        return MapLakesViewModel.Output(
            receivedLakesData: receivedLakesData,
            error: error
        )
    }
}

extension MapLakesViewModel: Flowable {
    struct Input {
        let receiveLakes: Driver<Void>
    }
    struct Output {
        let receivedLakesData: Driver<[MapLakeData]>
        let error: Driver<String>
    }
}

struct MapLakeData {
    let id: Int
    let title: String
    let lat: Double
    let lon: Double
}
