//
//  LakeDetailsProvider.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol LakeDetailsProviderProtocol {
    func configure(input: LakeDetailsProvider.Input) -> LakeDetailsProvider.Output
}

final class LakeDetailsProvider: LakeDetailsProviderProtocol {
    
    private let lakesRepository: LakesRepositoryProtocol
    
    init(lakesRepository: LakesRepositoryProtocol) {
        self.lakesRepository = lakesRepository
    }
    
    func configure(input: LakeDetailsProvider.Input) -> LakeDetailsProvider.Output {
        let receivedLake = input.receiveLake
            .flatMapLatest { [weak self] idLake -> Observable<Result<Lake,LakeError>> in
                guard let `self` = self else { return .empty() }
                let specification = LakeByIdSpecification(id: idLake)
                return self.lakesRepository
                    .fetchById(specification: specification)
        }
        return LakeDetailsProvider.Output(receivedLake: receivedLake)
    }
}

extension LakeDetailsProvider: Flowable {
    struct Input {
        let receiveLake: Observable<Int>
    }
    struct Output {
        let receivedLake: Observable<Result<Lake,LakeError>>
    }
}
