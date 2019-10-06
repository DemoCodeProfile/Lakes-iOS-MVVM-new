//
//  LakeDetailsConfiguration.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation

class LakeByIdSpecification: JsonSpecifiaction {
    private var mId: Int
    
    init(id: Int) {
        self.mId = id
    }
    
    func toJsonQuery() -> Int {
        return self.mId
    }
}
