//
//  FlowableConfiguration.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

protocol FlowableConfiguration: Flowable {
    func configure(input: Input) -> Output?
}
