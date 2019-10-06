//
//  UIViewController+Ext.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum TransitionScreen {
    case push
    case show
    case present
    case none
}

extension UIViewController {
    
    //    MARK: - Routing
    public static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return getTopViewController(base: navigationController.visibleViewController)
        } else if let tabBarController = base as? UITabBarController,
            let selected = tabBarController.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func showScreen(_ transition: TransitionScreen) {
        switch transition {
        case .push:
            push()
        case .show:
            show()
        case .present:
            present()
        default: break
        }
    }
    
    private func show() {
        UIViewController.getTopViewController()?.show(self, sender: nil)
    }
    
    private func push() {
        UIViewController.getTopViewController()?.navigationController?.pushViewController(self, animated: true)
    }
    
    private func present() {
        UIViewController.getTopViewController()?.present(self, animated: true, completion: nil)
    }
    
    func add(child: UIViewController) {
      addChild(child)
      view.addSubview(child.view)
      child.didMove(toParent: self)
    }

    func remove() {
      guard parent != nil else {
        return
      }
      willMove(toParent: nil)
      removeFromParent()
      view.removeFromSuperview()
    }
}
