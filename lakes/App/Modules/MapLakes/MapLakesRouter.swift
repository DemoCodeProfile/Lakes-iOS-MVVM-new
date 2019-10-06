//
//  MapLakesRouter.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MapLakesRouterProtocol {
    func showLakeDetailsScreen(input: LakeDetailsConfiguration.Input) -> LakeDetailsConfiguration.Output?
}

final class MapLakesRouter: MapLakesRouterProtocol {
    private weak var viewController: UIViewController?
    
    func setViewController(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showLakeDetailsScreen(input: LakeDetailsConfiguration.Input) -> LakeDetailsConfiguration.Output? {
        let configuration = LakeDetailsConfiguration()
        configuration.viewController?.modalPresentationStyle = .overCurrentContext
        return configuration.configure(input: input)
    }
}
