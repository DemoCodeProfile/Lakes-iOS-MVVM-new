//
//  MapLakesProvider.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MapLakesProviderProtocol {
    func configure(input: MapLakesProvider.Input) -> MapLakesProvider.Output
}

final class MapLakesProvider: MapLakesProviderProtocol {
    private var lakesRepository: LakesRepositoryProtocol
    
    init(lakesRepository: LakesRepositoryProtocol) {
        self.lakesRepository = lakesRepository
    }
    
    func configure(input: MapLakesProvider.Input) -> MapLakesProvider.Output {
        let receivedLakes = input.receiveLakes
            .flatMapLatest { [weak self] _ -> Observable<Result<[Lake], LakeError>> in
                guard let `self` = self else { return .empty() }
                return self.lakesRepository.fetchAll()
        }
        return MapLakesProvider.Output(
            receivedLakes: receivedLakes
        )
    }
}

extension MapLakesProvider: Flowable {
    struct Input {
        let receiveLakes: Observable<Void>
    }
    struct Output {
        let receivedLakes: Observable<Result<[Lake], LakeError>>
    }
}
