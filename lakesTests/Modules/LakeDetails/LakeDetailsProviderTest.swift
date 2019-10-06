//
//  LakeDetailsProviderTest.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxBlocking
import Quick
import Nimble

@testable import Lakes

class LakeDetailsProviderTest: QuickSpec {
    override func spec() {
        var provider: LakeDetailsProviderProtocol!
        var output: LakeDetailsProvider.Output!
        
        beforeEach {
            let repository = LakesRepositoryMock()
            provider = LakeDetailsProvider(lakesRepository: repository)
            let input = LakeDetailsProvider.Input(receiveLake: .just(1))
            output = provider.configure(input: input)
        }
        
        describe("Provider") {
            context("configure") {
                it("lake") {
                    let lake = try! output.receivedLake.toBlocking().first()!.value
                    expect(lake).to(equal(LakeFixture.lake))
                }
                it("error") {
                    let error = try! output.receivedLake.toBlocking().last()!.error
                    expect(error).to(matchError(LakeError.notFound("NotFound".translate())))
                }
            }
        }
    }
}
