//
//  LakeDetailsConfiguration.swift
//  lakes
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation

protocol JsonParserServiceProtocol {
    func parseAllLakes(_ dataString: String)->(Error?, [Lake]?)
}

class JsonParserService: JsonParserServiceProtocol {
    func parseAllLakes(_ dataString: String)->(Error?, [Lake]?){
        var lakes: [Lake]?
        var error: Error?
        if let data = dataString.data(using: .utf8) {
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, AnyObject>]
                if let response = response {
                    lakes = []
                    for data in response {
                        let id = data["id"] as? Int ?? 0
                        let title = data["title"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let img = data["img"] as? String
                        let lat = data["lat"] as? Double ?? 0.0
                        let lon = data["lon"] as? Double ?? 0.0
                        let lake = Lake(id: id, title: title, description: description, img: img, lat: lat, lon: lon)
                        lakes?.append(lake)
                    }
                }
            } catch let err {
                error = err
            }
        } else {
            error = LakeError.dataError("ErrorConvertData".translate())
        }
        return (error, lakes)
    }
    
}


