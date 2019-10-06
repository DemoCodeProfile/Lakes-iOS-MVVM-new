//
//  LakeDetailsViewController.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LakeDetailsViewControllerProtocol {
    
}

final class LakeDetailsViewController: UIViewController, UIGestureRecognizerDelegate {

    private let viewModel: LakeDetailsViewModelProtocol
    private let router: LakeDetailsRouterProtocol

    private let errorView = ErrorViewController()
    private let imageActivityIndicator = UIActivityIndicatorView()
    private let photo = UIImageView()
    private let titleLake = UILabel()
    private let descriptionLake = UILabel()
    private let disposeBag = DisposeBag()
    
    private var titleHeight: CGFloat = 30
    private var descriptionHeight: CGFloat = 30.0
    
    init(viewModel: LakeDetailsViewModelProtocol, router: LakeDetailsRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error decoder")
    }

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
        [
            imageActivityIndicator,
            photo,
            titleLake,
            descriptionLake
            ]
            .forEach { view.addSubview($0) }
    }
    
    private func configureUI() {
        view.backgroundColor = Theme.colors.background
        titleLake.textColor = Theme.colors.title
        titleLake.font = Theme.fonts.title
        descriptionLake.textColor = Theme.colors.body
        descriptionLake.font = Theme.fonts.body
        descriptionLake.numberOfLines = 0
    }
    
    private func layout() {
        photo.pin
            .top()
            .horizontally()
            .height(300)
        imageActivityIndicator.pin
            .top(80)
            .hCenter()
            .size(CGSize(width: 40, height: 40))
        titleLake.pin
            .below(of: photo)
            .horizontally(16)
            .marginTop(8)
            .height(titleHeight)
        descriptionLake.pin
            .below(of: titleLake)
            .horizontally(16)
            .height(descriptionHeight)
    }
}

extension LakeDetailsViewController: FlowableViewController {
    typealias Configuration = LakeDetailsConfiguration
    
    func configure(input: LakeDetailsConfiguration.Input) -> LakeDetailsConfiguration.Output {
        let receiveLake = BehaviorRelay<Int>(value: input.id)
        let receiveImage = PublishRelay<String>()
        let inputViewModel = LakeDetailsViewModel.Input(
            receiveLake: receiveLake.asDriver(),
            receiveImage: receiveImage.asDriver(onErrorJustReturn: "")
        )
        let outputViewModel = viewModel.configure(input: inputViewModel)
        receiveLake.asDriver()
            .mapToVoid()
            .drive(rx.showActivityIndicator)
            .disposed(by: disposeBag)
        let inputErrorView = ErrorViewController.Input(textError: outputViewModel.error)
        let outputErrorView = errorView.configuration(input: inputErrorView)
        outputErrorView.didTapRetry
            .map(to: input.id)
            .drive(receiveLake)
            .disposed(by: disposeBag)
        Driver.merge(
            outputViewModel.receivedLakeData.mapToVoid(),
            outputViewModel.error.mapToVoid()
        )
            .drive(rx.hideActivityIndicator)
            .disposed(by: disposeBag)
        outputViewModel.receivedLakeData
            .do(onNext: { [weak self] lakeData in
                self?.titleHeight = lakeData.title.height(withConstrainedWidth: UIScreen.main.bounds.width - 32, font: Theme.fonts.title)
                self?.descriptionHeight = lakeData.description.height(withConstrainedWidth: UIScreen.main.bounds.width - 32, font: Theme.fonts.body)
                self?.layout()
                self?.title = lakeData.title
            })
            .map { $0.title }
            .drive(titleLake.rx.text)
            .disposed(by: disposeBag)
        outputViewModel.receivedLakeData
            .map { $0.description }
            .drive(descriptionLake.rx.text)
            .disposed(by: disposeBag)
        outputViewModel.receivedLakeData
            .map { $0.img }
            .filterNil()
            .drive(onNext: receiveImage.accept)
            .disposed(by: disposeBag)
        outputViewModel.receivedImage
            .map(to: false)
            .drive(imageActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        outputViewModel.receivedImage
            .map { $0?.resizeImage(newWidth: UIScreen.main.bounds.width) }
            .drive(photo.rx.image)
            .disposed(by: disposeBag)
        return LakeDetailsConfiguration.Output()
    }
    
}

private extension Reactive where Base: LakeDetailsViewController {
    var showActivityIndicator: Binder<Void> {
        return Binder(base) { vc, _ in
            let alert = UIAlertController(
                title: nil,
                message: NSLocalizedString("Loading data...", comment: ""),
                preferredStyle: .alert
            )
            
            alert.view.tintColor = UIColor.black
            let loadingIndicator = UIActivityIndicatorView(
                frame: CGRect(x: 10, y: 5, width: 50, height: 50)
                ) as UIActivityIndicatorView
            
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = .gray
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            vc.navigationController?.present(alert, animated: false, completion: nil)
        }
    }
    
    var hideActivityIndicator: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.dismiss(animated: true, completion: nil)
        }
    }
}
