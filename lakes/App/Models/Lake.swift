//
//  Lake.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

struct Lake {
    var id: Int = 0
    var title: String = ""
    var description: String = ""
    var img: String?
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    init(id: Int, title: String, description: String, img: String?, lat: Double, lon: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.img = img
        self.lat = lat
        self.lon = lon
    }
}
