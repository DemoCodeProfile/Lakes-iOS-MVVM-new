//
//  ImageLoadingServiceMock.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift

@testable import Lakes

class ImageLoadingServiceMock: ImageLoadingServiceProtocol {
    func loadImage(_ url: URL) -> Observable<UIImage?> {
        return .just(nil)
    }
}
