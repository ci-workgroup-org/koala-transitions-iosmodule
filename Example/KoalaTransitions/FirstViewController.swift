//
//  FirstViewController.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import KoalaTransitions
import SnapKit
import SwiftyButton
import UIKit

class FirstViewController: UIViewController, CustomTransitions {
    var transitioner: Transitioner?
    let button = PressableButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "navigation"
        view.backgroundColor = [.lightText, .orange, .blue].randomElement()

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle("launch", for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }

    @objc func pressed() {
        let transitioner = Transitioner(animator: SlideAnimator(direction: .fromBottomToTop))
        let nextVC = FirstViewController()
        nextVC.transitioner = transitioner
        nextVC.setTransitioningDelegateToTransitioner()
        transitioningDelegate = transitioner
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
