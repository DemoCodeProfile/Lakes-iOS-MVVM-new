//
//  LakeDetailsService.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol LakeDetailsServiceProtocol {
    func configure(input: LakeDetailsService.Input) -> LakeDetailsService.Output
}

final class LakeDetailsService: LakeDetailsServiceProtocol {
    
    private var imageLoadingService: ImageLoadingServiceProtocol
    
    init(imageLoadingService: ImageLoadingServiceProtocol) {
        self.imageLoadingService = imageLoadingService
    }
    
    func configure(input: LakeDetailsService.Input) -> LakeDetailsService.Output {
        let receivedImage = input.receiveImage
            .flatMapLatest { [weak self] urlImage -> Observable<UIImage?> in
                guard let `self` = self, let url = URL(string: urlImage) else { return .just(nil) }
                return self.imageLoadingService.loadImage(url)
        }
        return LakeDetailsService.Output(
            receivedImage: receivedImage
        )
    }
}

extension LakeDetailsService: Flowable {
    struct Input {
        let receiveImage: Observable<String>
    }
    struct Output {
        let receivedImage: Observable<UIImage?>
    }
}
