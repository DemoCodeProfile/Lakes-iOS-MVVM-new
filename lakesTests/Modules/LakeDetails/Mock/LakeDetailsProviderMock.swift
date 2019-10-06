//
//  LakeDetailsProviderMock.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift

@testable import Lakes

class LakeDetailsProviderMock: LakeDetailsProviderProtocol {
    func configure(input: LakeDetailsProvider.Input) -> LakeDetailsProvider.Output {
        let result = Observable<Result<Lake,LakeError>>.of(
            .success(LakeFixture.lake),
            .failure(.notFound("NotFound".translate()))
        )
        return LakeDetailsProvider.Output(receivedLake: result)
    }
}

extension LakeData: Equatable {
    public static func == (lhs: LakeData, rhs: LakeData) -> Bool {
        return lhs.id == rhs.id
    }
}
