//
//  LakeDetailsViewModel.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LakeDetailsViewModelProtocol {
    func configure(input: LakeDetailsViewModel.Input) -> LakeDetailsViewModel.Output
}

final class LakeDetailsViewModel: LakeDetailsViewModelProtocol {
    
    private let provider: LakeDetailsProviderProtocol
    private let service: LakeDetailsServiceProtocol

    init(service: LakeDetailsServiceProtocol, provider: LakeDetailsProviderProtocol) {
        self.service = service
        self.provider = provider
    }
    
    func configure(input: LakeDetailsViewModel.Input) -> LakeDetailsViewModel.Output {
        let inputProvider = LakeDetailsProvider.Input(
            receiveLake: input.receiveLake.asObservable()
        )
        let inputService = LakeDetailsService.Input(receiveImage: input.receiveImage.asObservable())
        let outputProvider = provider.configure(input: inputProvider)
        let outputService = service.configure(input: inputService)
        let receivedLakeData = outputProvider.receivedLake
            .map {
                $0.value.map { lake -> LakeData in
                    LakeData(
                        id: lake.id,
                        title: lake.title,
                        description: lake.description,
                        img: lake.img,
                        lat: lake.lat,
                        lon: lake.lon
                    )
                }
            }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
        let error = outputProvider.receivedLake
            .map { $0.error?.description }
            .filterNil()
            .asDriver(onErrorJustReturn: "")
        return LakeDetailsViewModel.Output(
            receivedLakeData: receivedLakeData,
            receivedImage: outputService.receivedImage.asDriver(onErrorJustReturn: nil),
            error: error
        )
    }
}

extension LakeDetailsViewModel: Flowable {
    struct Input {
        let receiveLake: Driver<Int>
        let receiveImage: Driver<String>
    }
    struct Output {
        let receivedLakeData: Driver<LakeData>
        let receivedImage: Driver<UIImage?>
        let error: Driver<String>
    }
}

struct LakeData {
    let id: Int
    let title: String
    let description: String
    let img: String?
    let lat: Double
    let lon: Double
}
