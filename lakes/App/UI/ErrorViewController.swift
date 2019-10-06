//
//  EmptyViewController.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ErrorViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let logoType = UIImageView()
    private let errorLabel = UILabel()
    private let retryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        configureUI()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func createUI() {
        [logoType, errorLabel, retryButton].forEach { view.addSubview($0) }
    }
    
    private func configureUI() {
        logoType.image = UIImage(named: "launchScreen")
        logoType.contentMode = .scaleAspectFit
        errorLabel.numberOfLines = 0
        errorLabel.textColor = Theme.colors.error
        errorLabel.font = Theme.fonts.error
        errorLabel.textAlignment = .center
        retryButton.setAttributedTitle(
            NSAttributedString(
                string: "TryAgain".translate(),
                attributes: [.foregroundColor: Theme.colors.title]
        ), for: .normal)
        view.backgroundColor = Theme.colors.background
    }
    
    private func layout() {
        logoType.pin
            .vCenter(-80)
            .hCenter()
            .size(CGSize(width: UIScreen.main.bounds.width / 2, height: 150))
        errorLabel.pin
            .below(of: logoType)
            .horizontally(16)
            .height(60)
        retryButton.pin
            .below(of: errorLabel)
            .horizontally(16)
            .height(40)
    }
}

extension ErrorViewController: Flowable {
    struct Input {
        let textError: Driver<String>
    }
    struct Output {
        let didTapRetry: Driver<Void>
    }
    
    func configuration(input: Input) -> Output {
        input.textError
            .drive(onNext: { [weak self] errorText in
                guard let `self` = self else { return }
                self.errorLabel.text = errorText
                UIViewController.getTopViewController()?.add(child: self)
            })
            .disposed(by: disposeBag)
        let didTapRetry = retryButton.rx.tap.asDriver()
            .do(onNext: { [weak self] _ in
                self?.remove()
            })
        return Output(didTapRetry: didTapRetry)
    }
}
