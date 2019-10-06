//
//  LakesRepositoryMock.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift
import RxTest

@testable import Lakes

class LakesRepositoryMock: LakesRepositoryProtocol {
    func fetchAll() -> Observable<Result<[Lake], LakeError>> {
        return Observable<Result<[Lake], LakeError>>
            .of(
                .success([LakeFixture.lake]),
                .failure(.undefened("undefened"))
        )
    }
    
    func fetchById(specification: BaseSpecification?) -> Observable<Result<Lake, LakeError>> {
        return Observable.of(.success(LakeFixture.lake), .failure(.notFound("NotFound".translate())))
    }
}
