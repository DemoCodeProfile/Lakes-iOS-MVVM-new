//
//  LakeDetailsConfiguration.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation
import RxSwift

protocol LakeDetailsConfigurationProtocol { }

final class LakeDetailsConfiguration: LakeDetailsConfigurationProtocol {
    
    let viewController: UIViewController?

    init() {
        let imageLoadingService = DI.instance.container.resolve(ImageLoadingServiceProtocol.self)
        let lakesRepository = DI.instance.container.resolve(LakesRepositoryProtocol.self)
        let provider = LakeDetailsProvider(lakesRepository: lakesRepository)
        let service = LakeDetailsService(imageLoadingService: imageLoadingService)
        let router = LakeDetailsRouter()
        let viewModel = LakeDetailsViewModel(service: service, provider: provider)
        viewController = LakeDetailsViewController(viewModel: viewModel, router: router)
        router.setViewController(viewController: viewController)
    }
}

extension LakeDetailsConfiguration: FlowableConfiguration {
    func configure(input: Input) -> Output? {
        let output = configureStart(input: input)
        viewController?.showScreen(input.transition)
        return output
    }
    
    @discardableResult
    func configureStart(input: Input) -> Output? {
        return (viewController as? LakeDetailsViewController)?.configure(input: input)
    }
    
    struct Input {
        let id: Int
        let transition: TransitionScreen
    }
    
    struct Output { }
}
