//
//  ListViewController.swift
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

class ListViewController: UIViewController {
    let button = PressableButton()
    let topButton = PressableButton()
    let bottomLeftButton = PressableButton()
    var transitioner: Transitioner?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
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
    }

    @objc func pressed(_ button: UIControl) {
        transitioner = Transitioner(animator: ExpandFromFrameAnimator(button.frameInSuperview))
        let nextVC = DetailsViewController()
        nextVC.transitioner = transitioner
        nextVC.transitioningDelegate = transitioner
        present(nextVC, animated: true)
    }
}
