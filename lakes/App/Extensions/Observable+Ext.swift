//
//  Observable+Ext.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

extension Observable {
    func filterNil<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
    func asDriver(justNilElement: Element?) -> SharedSequence<DriverSharingStrategy, Element?> {
        return self.map { Optional($0) }.asSharedSequence(onErrorJustReturn: justNilElement)
    }
}
