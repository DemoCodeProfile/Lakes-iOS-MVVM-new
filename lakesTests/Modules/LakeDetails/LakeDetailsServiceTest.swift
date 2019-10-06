//
//  LakeDetailsServiceTest.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Quick
import Nimble

@testable import Lakes

class LakeDetailsServiceTest: QuickSpec {
    override func spec() {
        var service: LakeDetailsServiceProtocol!
        var output: LakeDetailsService.Output!
        
        beforeEach {
            let imageLoadingService = ImageLoadingServiceMock()
            service = LakeDetailsService(imageLoadingService: imageLoadingService)
            let input = LakeDetailsService.Input(receiveImage: .just(""))
            output = service.configure(input: input)
        }
        
        describe("Service") {
            context("configure") {
                it("photo nil") {
                    let image = try! output.receivedImage.toBlocking().first()!
                    expect(image).to(beNil())
                }
            }
        }
    }
}
