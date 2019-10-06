//
//  DefaultThemeColors.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

struct DefaultThemeColors: ThemeColors {
    var main = UIColor.hexStringToUIColor(hex: "#CD0B0B")
    var title = UIColor.twoModeColor(
        light: .black,
        dark: UIColor.hexStringToUIColor(hex: "#f1f1f1")
    )
    var error = UIColor.twoModeColor(
        light: UIColor.hexStringToUIColor(hex: "#777777"),
        dark: UIColor.hexStringToUIColor(hex: "#f1f1f1")
    )
    
    var body = UIColor.twoModeColor(
        light: UIColor.hexStringToUIColor(hex: "#777777"),
        dark: UIColor.hexStringToUIColor(hex: "#f1f1f1")
    )
    var background = UIColor.twoModeColor(
        light: .white,
        dark: UIColor.hexStringToUIColor(hex: "#333333")
    )
}
