//
//  MapLakesProviderMock.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift
@testable import Lakes

class MapLakesProviderMock: MapLakesProviderProtocol {
    func configure(input: MapLakesProvider.Input) -> MapLakesProvider.Output {
        let receivedLakes = Observable<Result<[Lake], LakeError>>.of(.success([LakeFixture.lake]), .failure(.notFound("NotFound".translate())))
        return MapLakesProvider.Output(receivedLakes: receivedLakes)
    }
}
