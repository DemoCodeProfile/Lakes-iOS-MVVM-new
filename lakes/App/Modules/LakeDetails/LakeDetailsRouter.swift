//
//  LakeDetailsRouter.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LakeDetailsRouterProtocol {
    
}

final class LakeDetailsRouter: LakeDetailsRouterProtocol {
    private weak var viewController: UIViewController?
    
    func setViewController(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
