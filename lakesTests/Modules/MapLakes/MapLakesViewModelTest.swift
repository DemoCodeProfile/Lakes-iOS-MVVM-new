//
//  MapLakesViewModelTest.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import XCTest

@testable import Lakes

class MapLakesViewModelTest: XCTestCase {
    
    var service: MapLakesServiceProtocol!
    var provider: MapLakesProviderProtocol!
    var viewModel: MapLakesViewModelProtocol!
    var output: MapLakesViewModel.Output!
    
    override func setUp() {
        service = MapLakesServiceMock()
        provider = MapLakesProviderMock()
        viewModel = MapLakesViewModel(service: service, provider: provider)
        let input = MapLakesViewModel.Input(
            receiveLakes: .just(())
        )
        output = viewModel.configure(input: input)
    }

    override func tearDown() { }
    
    func testViewModelLakesReceivedCount() {
        let lakes = try! output.receivedLakesData.toBlocking().first()!
        XCTAssertEqual(lakes.count, 1)
    }
    
    func testViewModelReceivedLakeError() {
        let error = try! output.error.toBlocking().first()!
        XCTAssertEqual(error, "NotFound".translate())
    }
}
