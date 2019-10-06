//
//  MapLakesConfiguration.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation
import RxSwift

protocol MapLakesConfigurationProtocol { }

final class MapLakesConfiguration: MapLakesConfigurationProtocol {
    
    let viewController: UIViewController?

    init() {
        let lakesRepository = DI.instance.container.resolve(LakesRepositoryProtocol.self)
        let provider = MapLakesProvider(lakesRepository: lakesRepository)
        let service = MapLakesService()
        let router = MapLakesRouter()
        let viewModel = MapLakesViewModel(service: service, provider: provider)
        viewController = MapLakesViewController(viewModel: viewModel, router: router)
        router.setViewController(viewController: viewController)
    }
}

extension MapLakesConfiguration: FlowableConfiguration {

    func configure(input: Input) -> Output? {
        let output = configureStart(input: input)
        viewController?.showScreen(input.transition)
        return output
    }
    
    @discardableResult
    func configureStart(input: Input) -> Output? {
        return (viewController as? MapLakesViewController)?.configure(input: input)
    }
    
    struct Input {
        let transition: TransitionScreen
    }
    
    struct Output { }
}

