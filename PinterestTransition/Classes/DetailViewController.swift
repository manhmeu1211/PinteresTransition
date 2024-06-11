//
//  DetailViewController.swift
//  PinteresTransition
//
//  Created by đào sơn on 06/06/2024.
//

import UIKit
import Stevia

public class DetailViewController: UIViewController {
    public let zoomedView = UIView()
    var initialImageViewFrame: CGRect?
    private var childVC: UIViewController

    public init(childVC: UIViewController) {
        self.childVC = childVC
        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupZoomedView()
        self.transitioningDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupZoomedView() {
        zoomedView.backgroundColor = .clear
        zoomedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoomedView)
        zoomedView.fillContainer()
        addChild(childVC, to: zoomedView)
    }

    func animateView(from initialView: UIView) {
        guard let initialSuperview = initialView.superview else { return }
        let initialFrame = initialSuperview.convert(initialView.frame, to: view)

        zoomedView.frame = initialFrame
        zoomedView.layer.cornerRadius = initialView.layer.cornerRadius
        zoomedView.layer.masksToBounds = initialView.layer.masksToBounds

        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1.0) {
            self.zoomedView.frame = self.view.bounds
            self.zoomedView.layer.cornerRadius = 0
        }.startAnimation()
    }

    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageDismissAnimator(initialFrame: initialImageViewFrame ?? .zero)
    }
}
