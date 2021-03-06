//
//  ExpandingExampleMainController.swift
//  KoalaTransitions_Example
//
//  Created by Nicholas Trienens on 5/20/19.
//

import Foundation
import KoalaTransitions
import SnapKit
import SwiftyButton
import UIKit

extension ExpandingExample {
    class MainController: UIViewController {
        let button = PressableButton()
        let topButton = PressableButton()
        let bottomLeftButton = UIButton()
        let bottomRightButton = UIButton()
        var transitioner: Transitioner?

        var preloadElements = [ElementInterface]()
        var rightButtonSnapshot: UIImage?

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .lightGray

            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(50)
                make.width.equalTo(140)
                make.height.equalTo(50)
            }
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitle("launch", for: .normal)
            button.addTarget(self, action: #selector(pressed), for: .touchUpInside)

            view.addSubview(topButton)
            topButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(50)
                make.centerX.equalToSuperview()
                make.width.equalTo(140)
                make.height.equalTo(50)
            }
            topButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            topButton.setTitle("launch", for: .normal)
            topButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)

            view.addSubview(bottomLeftButton)
            bottomLeftButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(100)
                make.leading.equalToSuperview().inset(30)
                make.height.width.equalTo(120)
            }
            bottomLeftButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            bottomLeftButton.setImage(UIImage(named: "image"), for: [])
            bottomLeftButton.addTarget(self, action: #selector(pressedMatchedImage), for: .touchUpInside)

            view.addSubview(bottomRightButton)
            bottomRightButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(100)
                make.trailing.equalToSuperview().inset(30)
                make.height.width.equalTo(120)
            }
            bottomRightButton.setImage(UIImage(named: "image"), for: [])
            bottomRightButton.addTarget(self, action: #selector(pressedBottomRightButton), for: .touchUpInside)
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            if rightButtonSnapshot == nil {
                rightButtonSnapshot = bottomRightButton.snapshot()
            }
            if preloadElements.isEmpty {
                let fromView = Element<DetailsAnimatableElements>(view: bottomLeftButton, use: .topView, snapshot: bottomLeftButton.snapshot())
                // let leftView = Element<DetailsAnimatableElements>(view: bottomLeftButton, use: .leftView)
                preloadElements = [fromView] // , leftView]
            }
        }

        @objc func pressed(_ button: UIControl) {
            let nextVC = DetailsViewController()
            let transitioner = Transitioner(animator: ExpandFromFrameAnimator(button.frameInSuperview.squared(), duration: 0.5))
            nextVC.setTransitioner(transitioner)
            present(nextVC, animated: true)
        }

        @objc func pressedBottomRightButton(_ button: UIControl) {
            let nextVC = DetailsViewController()
            let navigationController = AnimatedNavigationController(rootViewController: nextVC)
            navigationController.setTransitioner(Transitioner(animator: MatchedViewExpandFromFrameAnimator(
                bottomRightButton.frameInSuperview,
                originView: bottomRightButton,
                originSnapshot: rightButtonSnapshot,
                finalView: nextVC.topView,
                duration: 0.8
            )))

            present(navigationController, animated: true)
        }

        @objc func pressedMatchedImage(_ button: UIControl) {
            let nextVC = DetailsViewController()

            let elementAnimations = preloadElements.matchPairs(nextVC.elementsForAnimtion())

            let transitioner = Transitioner(
                animator: MatchedElementsAnimator(
                    bottomLeftButton.frameInSuperview,
                    elementPairs: elementAnimations,
                    duration: 0.8
                )
            )
            nextVC.setTransitioner(transitioner)
            present(nextVC, animated: true)
        }
    }
}
