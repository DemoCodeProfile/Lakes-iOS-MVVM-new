//
//  LakeDetailsConfiguration.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift

protocol ImageLoadingServiceProtocol: class {
    func loadImage(_ url: URL)->Observable<UIImage?>
}

class ImageLoadingService: ImageLoadingServiceProtocol {
    func loadImage(_ url: URL)->Observable<UIImage?> {
        return Observable<UIImage?>
            .create { observer -> Disposable in
                SDWebImageManager.shared
                    .loadImage(
                        with: url,
                        options: .refreshCached,
                        progress: nil
                    ) { image, data, error, type, finished, url in
                        observer.onNext(image)
                        observer.onCompleted()
                }
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
