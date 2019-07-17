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
            bottomRightButton.addTarget(self, action: #selector(pressedImage), for: .touchUpInside)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let fromView = Element<DetailsAnimatableElements>(view: bottomLeftButton, use: .topView, snapshot: bottomLeftButton.snapshot())
            let leftView = Element<DetailsAnimatableElements>(view: bottomLeftButton, use: .leftView)
            preloadElements = [fromView, leftView]
        }

        @objc func pressed(_ button: UIControl) {
            let nextVC = DetailsViewController()
            nextVC.transitioner = Transitioner(animator: ExpandFromFrameAnimator(button.frameInSuperview, duration: 0.3))
            nextVC.setTransitioningDelegateToTransitioner()
            present(nextVC, animated: true)
        }

        @objc func pressedImage(_ button: UIControl) {
            let nextVC = DetailsViewController()

            nextVC.setTransitioner(Transitioner(animator: MatchedViewExpandFromFrameAnimator(button.frameInSuperview, originView: button, finalView: nextVC.topView)))

            present(nextVC, animated: true)
        }

        @objc func pressedMatchedImage(_ button: UIControl) {
            let nextVC = DetailsViewController()

            let elementAnimations = preloadElements.matchPairs(nextVC.elements())

            let transitioner = Transitioner(animator: MatchedElementsAnimator(button.frameInSuperview, elementPairs: elementAnimations))
            nextVC.setTransitioner(transitioner)
            present(nextVC, animated: true)
        }
    }
}
