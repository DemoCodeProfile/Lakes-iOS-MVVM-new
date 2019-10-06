//
//  LakeDetailsServiceMock.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

@testable import Lakes
import UIKit

class LakeDetailsServiceMock: LakeDetailsServiceProtocol {
    func configure(input: LakeDetailsService.Input) -> LakeDetailsService.Output {
        return LakeDetailsService.Output(receivedImage: .just(nil))
    }
}
