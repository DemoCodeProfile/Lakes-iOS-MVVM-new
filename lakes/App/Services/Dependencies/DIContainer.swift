//
//  DIContainer.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

protocol DIContainerProtocol {
    associatedtype Scope
    func register<T>(depedency: T.Type, implemenation: @escaping () -> T, objectScope: Scope, tag: String?)
    func resolve<T>(_ dependency: T.Type, tag: String?) -> T
}

protocol DIContainerServiceProtocol {
    func registerServices()
    func resolve<T>(_ dependency: T.Type) -> T
}
