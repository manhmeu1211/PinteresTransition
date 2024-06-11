//
//  ImageDismissAnimator.swift
//  PinteresTransition
//
//  Created by đào sơn on 06/06/2024.
//

import UIKit

public class ImageDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var initialFrame: CGRect

    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? DetailViewController,
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        guard let snapshotView = fromVC.zoomedView.snapshotView(afterScreenUpdates: false) else {
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = initialFrame

        snapshotView.frame = fromVC.zoomedView.frame
        snapshotView.layer.cornerRadius = fromVC.zoomedView.layer.cornerRadius
        snapshotView.layer.masksToBounds = fromVC.zoomedView.layer.masksToBounds

        containerView.addSubview(snapshotView)
        fromVC.zoomedView.isHidden = true
        fromVC.view.backgroundColor = .clear

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshotView.frame = finalFrame
            toVC.view.alpha = 1.0
        }) { finished in
            fromVC.view.removeFromSuperview()
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}
