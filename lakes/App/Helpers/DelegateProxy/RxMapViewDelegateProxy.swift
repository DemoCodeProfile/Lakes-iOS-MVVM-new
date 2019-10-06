//
//  RxMapViewDelegateProxy.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa
import MapKit

class RxMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, MKMapViewDelegate, DelegateProxyType {
    
    fileprivate let didSelectAnnotation = PublishRelay<MKAnnotation?>()
    public weak private(set) var mapView: MKMapView?
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMapViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { RxMapViewDelegateProxy(mapView: $0) }
    }
    
    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        didSelectAnnotation.accept(view.annotation)
    }
}

extension Reactive where Base: MKMapView {
    var delegate: RxMapViewDelegateProxy {
        return RxMapViewDelegateProxy.proxy(for: base)
    }
    
    var annotations: Binder<[MKAnnotation]> {
        return Binder(base) { mapView, annotations in
            mapView.addAnnotations(annotations)
        }
    }
    
    var didSelectAnnotation: ControlEvent<MKAnnotation?> {
        return ControlEvent(events: delegate.didSelectAnnotation.asObservable())
    }
}

