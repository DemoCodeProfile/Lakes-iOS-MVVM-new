//
//  AnimationPush.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

class AnimationCircle: NSObject, UIViewControllerAnimatedTransitioning {
    let centerView: CGPoint
    let operation: UINavigationController.Operation
    
    init(centerView: CGPoint, operation: UINavigationController.Operation) {
        self.centerView = centerView
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
            else {
                transitionContext.completeTransition(transitionContext.transitionWasCancelled)
                return
        }
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let roundedView = createRoundedView(sideRect: finalFrame.height)
        switch operation {
        case .push:
            push(
                transitionContext: transitionContext,
                toView: toView,
                roundedView: roundedView,
                finalFrame: finalFrame
            )
        case .pop:
            pop(
                transitionContext: transitionContext,
                fromView: fromView,
                toView: toView,
                roundedView: roundedView,
                finalFrame: finalFrame
            )
        default:
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
        }
    }
    
    private func push(transitionContext: UIViewControllerContextTransitioning, toView: UIView, roundedView: UIView, finalFrame: CGRect) {
        roundedView.alpha = 1.0
        roundedView.center = centerView
        roundedView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        toView.center = centerView
        toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        toView.alpha = 0.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(roundedView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                toView.alpha = 1.0
                toView.frame = finalFrame
                roundedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                roundedView.alpha = 0.0
                roundedView.center = toView.center
                
        }) { _ in
            roundedView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func pop(
        transitionContext: UIViewControllerContextTransitioning,
        fromView: UIView,
        toView: UIView,
        roundedView: UIView,
        finalFrame: CGRect
    ) {
        roundedView.alpha = 1.0
        roundedView.center = toView.center
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)
        containerView.addSubview(roundedView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                roundedView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                roundedView.alpha = 0.0
                roundedView.center = self.centerView
                fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                fromView.alpha = 0.0
                fromView.center = self.centerView
        }) { _ in
            roundedView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func createRoundedView(sideRect: CGFloat) -> UIView {
        let roundedToView = UIView()
        roundedToView.frame = CGRect(x: 0, y: 0, width: sideRect, height: sideRect)
        roundedToView.layer.cornerRadius = sideRect / 2
        roundedToView.backgroundColor = Theme.colors.background
        return roundedToView
    }
}
