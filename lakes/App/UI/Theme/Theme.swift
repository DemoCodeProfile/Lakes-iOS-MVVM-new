//  Theme.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.

import UIKit

struct Theme {
    private static var theme: ThemeApp {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .light {
                return DefaultTheme()
            }
        }
        return DefaultTheme()
    }
    static var colors: ThemeColors = Theme.theme.colors
    static var fonts: ThemeFonts  = Theme.theme.fonts
}
