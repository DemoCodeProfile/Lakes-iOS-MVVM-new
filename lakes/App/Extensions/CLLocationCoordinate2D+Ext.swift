//
//  CLLocationCoordinate2D+Ext.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
    func isEqual(coordinate: CLLocationCoordinate2D) -> Bool {
        return self.latitude == coordinate.latitude && self.longitude == coordinate.longitude
    }
}
