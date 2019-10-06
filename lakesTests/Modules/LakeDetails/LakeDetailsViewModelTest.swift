//
//  LakeDetailsViewModelTest.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Quick
import Nimble
import RxBlocking

@testable import Lakes

class LakeDetailsViewModelTest: QuickSpec {
    
    override func spec() {
        var service: LakeDetailsServiceProtocol!
        var provider: LakeDetailsProviderProtocol!
        var viewModel: LakeDetailsViewModelProtocol!
        var output: LakeDetailsViewModel.Output!
        
        beforeEach {
            service = LakeDetailsServiceMock()
            provider = LakeDetailsProviderMock()
            viewModel = LakeDetailsViewModel(service: service, provider: provider)
            let input = LakeDetailsViewModel.Input(
                receiveLake: .just(1),
                receiveImage: .just("")
            )
            output = viewModel.configure(input: input)
        }
        
        describe("ViewModel") {
            context("configure") {
                it("photo nil") {
                    expect(try! output.receivedImage.toBlocking().first()!)
                        .to(beNil())
                }
                it("lake") {
                    let lakeMock = LakeFixture.lake
                    let lakeDataMock = LakeData(
                        id: lakeMock.id,
                        title: lakeMock.title,
                        description: lakeMock.description,
                        img: lakeMock.img,
                        lat: lakeMock.lat,
                        lon: lakeMock.lon
                    )
                    let lakeData = try! output.receivedLakeData.toBlocking().first()!
                    expect(lakeData).to(equal(lakeDataMock))
                }
                it("lake error") {
                    let error = try! output.error.toBlocking().first()!
                    expect(error) == "NotFound".translate()
                }
            }
        }
    }
}
