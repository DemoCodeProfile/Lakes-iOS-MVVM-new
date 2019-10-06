//
//  FlowableViewController.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

protocol FlowableViewController {
    associatedtype Configuration: FlowableConfiguration
    func configure(input: Configuration.Input) -> Configuration.Output
}
