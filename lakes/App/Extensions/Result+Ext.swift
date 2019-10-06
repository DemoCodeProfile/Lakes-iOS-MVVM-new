//
//  Result+Ext.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    var value: Success? {
        if case .success(let result) = self {
            return result
        }
        return nil
    }
    var error: Failure? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}
