//
//  DIContainer.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Swinject

class DIContainerSwinject: DIContainerProtocol {
    private let container = Container()
    
    func register<T>(
        depedency: T.Type,
        implemenation: @escaping () -> T,
        objectScope: ObjectScope = .graph,
        tag: String? = nil
    ) {
        container.register(depedency, name: tag, factory: { _ in implemenation() }).inObjectScope(objectScope)
    }
    
    func resolve<T>(_ dependency: T.Type, tag: String? = nil) -> T {
      guard let implementation = container.resolve(dependency, name: tag) else {
        fatalError("Not found")
      }
      return implementation
    }
}

class DIContainerService: DIContainerServiceProtocol {
    private let container = DIContainerSwinject()
    
    func registerServices() {
        container.register(
            depedency: JsonParserServiceProtocol.self,
            implemenation: { () -> JsonParserService in
                return JsonParserService()
        },
            objectScope: .graph
        )
        container.register(
            depedency: LakesRepositoryProtocol.self,
            implemenation: { [weak self] () -> JsonLakesRepository in
                guard let `self` = self else { fatalError("Fatal error container") }
                return JsonLakesRepository(
                    jsonParserService: self.resolve(JsonParserServiceProtocol.self)
                )
        },
            objectScope: .graph
        )
        container.register(
            depedency: BaseSpecification.self,
            implemenation: { () -> LakeByIdSpecification in
                return LakeByIdSpecification(id: 0)
        },
            objectScope: .graph,
            tag: "lakeById"
        )
        container.register(
            depedency: ImageLoadingServiceProtocol.self,
            implemenation: { () -> ImageLoadingService in
                return ImageLoadingService()
        },
            objectScope: .graph
        )
    }
    
    func resolve<T>(_ dependency: T.Type) -> T {
        return container.resolve(dependency)
    }
}
