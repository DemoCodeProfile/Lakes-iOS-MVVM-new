//
//  MapLakesViewController.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import PinLayout

protocol MapLakesViewControllerProtocol { }

final class MapLakesViewController: UIViewController {

    private let viewModel: MapLakesViewModelProtocol
    private let router: MapLakesRouterProtocol
    
    private let mapView = MKMapView()
    private let errorView = ErrorViewController()
    private var centerPoint: CGPoint = CGPoint(x: 0, y: 0)

    private let disposeBag = DisposeBag()
    
    init(viewModel: MapLakesViewModelProtocol, router: MapLakesRouterProtocol) {
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
        view.addSubview(mapView)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "Lakes".translate()
        navigationController?.delegate = self
    }
    
    private func layout() {
        mapView.pin.all()
    }
}

extension MapLakesViewController: FlowableViewController {
    typealias Configuration = MapLakesConfiguration
    
    func configure(input: MapLakesConfiguration.Input) -> MapLakesConfiguration.Output {
        let receiveLakes = BehaviorRelay<Void>(value: ())
        let inputViewModel = MapLakesViewModel.Input(
            receiveLakes: receiveLakes.asDriver()
        )
        let outputViewModel = viewModel.configure(
            input: inputViewModel
        )
        let inputErrorView = ErrorViewController.Input(textError: outputViewModel.error)
        let outputErrorView = errorView.configuration(input: inputErrorView)
        outputErrorView.didTapRetry
            .drive(receiveLakes)
            .disposed(by: disposeBag)
        outputViewModel.receivedLakesData
            .map { lakes -> [MKPointAnnotation] in
                lakes.map {
                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
                    annotation.coordinate = centerCoordinate
                    annotation.title = $0.title
                    return annotation
                }
            }
            .drive(mapView.rx.annotations)
            .disposed(by: disposeBag)
        mapView.rx.didSelectAnnotation
            .asDriver()
            .withLatestFrom(outputViewModel.receivedLakesData) { [weak self] annotation, dataLakes -> Int? in
                guard let `self` = self, let annotation = annotation else { return nil }
                self.centerPoint = self.mapView.view(for: annotation)?.center ?? self.view.center
                let lake = dataLakes.first {
                    CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
                        .isEqual(coordinate: annotation.coordinate)
                }
                return lake?.id
            }
            .filterNil()
            .flatMapLatest { [weak self] idLake -> Driver<LakeDetailsConfiguration.Output?> in
                let output = self?.router.showLakeDetailsScreen(
                    input: LakeDetailsConfiguration.Input(id: idLake, transition: .push)
                )
                return .just(output)
            }
            .drive()
            .disposed(by: disposeBag)
        return MapLakesConfiguration.Output()
    }
}

extension MapLakesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push, .pop:
            return AnimationCircle(centerView: centerPoint, operation: operation)
        default:
            return nil
        }
    }
}
