//
//  SharedSequence+Ext.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxCocoa

extension SharedSequence {
    func map<InstanceType>(to instance: InstanceType) -> SharedSequence<SharingStrategy, InstanceType> {
        return self.map { _ in instance }
    }
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return self.map { _ in () }
    }
    
    func filterNil<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
