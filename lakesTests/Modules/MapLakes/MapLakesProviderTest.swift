//
//  MapLakesProviderTest.swift
//  lakesTests
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import XCTest

@testable import Lakes

class MapLakesProviderTest: XCTestCase {
    
    var provider: MapLakesProviderProtocol!
    var output: MapLakesProvider.Output!
    
    override func setUp() {
        let repository = LakesRepositoryMock()
        provider = MapLakesProvider(lakesRepository: repository)
        let input = MapLakesProvider.Input(receiveLakes: .just(()))
        output = provider.configure(input: input)
    }

    override func tearDown() { }
    
    func testProviderLakesReceived() {
        let lakes = try! output.receivedLakes.toBlocking().first()!.value!
        XCTAssertEqual(lakes.count, 1)
    }
    
    func testProviderLakesReceivedError() {
        let error = try! output.receivedLakes.toBlocking().last()!.error!
        XCTAssertEqual(error, LakeError.undefened("undefened".translate()))
    }
}
