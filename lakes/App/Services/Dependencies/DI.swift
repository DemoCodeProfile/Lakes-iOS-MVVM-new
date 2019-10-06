//
//  DI.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

class DI {
    static let instance = DI()
    let container: DIContainerServiceProtocol = DIContainerService()
}
