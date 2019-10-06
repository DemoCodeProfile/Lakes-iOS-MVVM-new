//
//  LakeFixture.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

@testable import Lakes

class LakeFixture {
    static let lake = Lake(id: 1, title: "Baikal", description: "The biggest lake", img: nil, lat: 10.0, lon: 11.0)
}

extension Lake: Equatable {
    public static func == (lhs: Lake, rhs: Lake) -> Bool {
        return lhs.id == rhs.id
    }
}
