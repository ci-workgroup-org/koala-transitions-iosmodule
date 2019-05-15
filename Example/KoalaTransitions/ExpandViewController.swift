//
//  ExpandViewController.swift
//  KoalaTransitions_Example
//
//  Created by boulder on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import KoalaTransitions
import SnapKit
import SwiftyButton
import UIKit

class ExpandViewController: UIViewController {
    let button = PressableButton()
    let topButton = PressableButton()
    let bottomLeftButton = PressableButton()
    let bottomRightButton = UIButton()
    var transitioner: Transitioner?
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
            make.leading.equalToSuperview().inset(50)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        bottomLeftButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        bottomLeftButton.setTitle("launch", for: .normal)
        bottomLeftButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)

        view.addSubview(bottomRightButton)
        bottomRightButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.trailing.equalToSuperview().inset(50)
            make.height.width.equalTo(140)
        }
        bottomRightButton.setImage(UIImage(named: "image"), for: [])
        bottomRightButton.addTarget(self, action: #selector(pressedImage), for: .touchUpInside)
    }

    @objc func pressed(_ button: UIControl) {
        let nextVC = DetailsViewController()
        nextVC.transitioner = Transitioner(animator: ExpandFromFrameAnimator(button.frameInSuperview))
        nextVC.setTransitioningDelegateToTransitioner()
        present(nextVC, animated: true)
    }

    @objc func pressedImage(_ button: UIControl) {
        let nextVC = DetailsViewController()
        nextVC.transitioner = Transitioner(animator: MatchedItemsExpandFromFrameAnimator(button.frameInSuperview, originViewImage: UIImage(named: "image")!))
        nextVC.setTransitioningDelegateToTransitioner()
        present(nextVC, animated: true)
    }
}
