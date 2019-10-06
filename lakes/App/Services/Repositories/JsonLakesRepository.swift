//
//  LakeDetailsConfiguration.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation
import RxSwift

enum LakeError: Error, Equatable {
    case notFound(String), dataError(String), undefened(String)
    
    var description: String {
        switch self {
        case .notFound(let data), .dataError(let data), .undefened(let data):
            return data
        }
    }
}

protocol LakesRepositoryProtocol: class {
    func fetchAll() -> Observable<Result<[Lake], LakeError>>
    func fetchById(specification: BaseSpecification?) -> Observable<Result<Lake, LakeError>>
}

class JsonLakesRepository: LakesRepositoryProtocol {
    
    var jsonParserService: JsonParserServiceProtocol
    
    init(jsonParserService: JsonParserServiceProtocol) {
        self.jsonParserService = jsonParserService
    }
    
    func fetchAll() -> Observable<Result<[Lake], LakeError>> {
        return Observable<Result<[Lake], LakeError>>
            .create { [weak self] observer -> Disposable in
                guard let `self` = self else { return Disposables.create() }
                let (error, data) = self.jsonParserService.parseAllLakes(JSON_DATA_FROM_SERVER)
                if let error = error {
                    observer.onNext(
                        .failure(
                            .undefened(error.localizedDescription)
                        )
                    )
                } else if let data = data {
                    observer.onNext(.success(data))
                }
                return Disposables.create()
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
    
    func fetchById(specification: BaseSpecification?) -> Observable<Result<Lake, LakeError>> {
        return Observable<Result<Lake, LakeError>>
            .create({[weak self] observer -> Disposable in
                guard let `self` = self else { return Disposables.create() }
                if let specification = specification as? JsonSpecifiaction {
                    let id = specification.toJsonQuery()
                    let (error, lakes) = self.jsonParserService.parseAllLakes(JSON_DATA_FROM_SERVER)
                    if let error = error {
                        observer.onError(error)
                    }
                    if let lakes = lakes, id != 0 {
                        for l in lakes {
                            if l.id == id {
                                observer.onNext(.success(l))
                                break
                            }
                        }
                    } else {
                        observer.onNext(
                            .failure(
                                .notFound("NotFound".translate())
                            )
                        )
                    }
                } else {
                    observer.onNext(
                        .failure(
                            LakeError.dataError("ErrorIdData".translate())
                        )
                    )
                }
                return Disposables.create()
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
}
