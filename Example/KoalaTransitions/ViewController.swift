//
//  ViewController.swift
//  KoalaTransitions_Example
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import KoalaTransitions
import SnapKit
import SwiftyButton
import UIKit

class ViewController: UIViewController {
    let button = PressableButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Modal"
        let label = Label()
        label.text = "Modal With Push Animation"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
        }

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(40)
            make.center.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle("launch", for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func pressed() {
        let transitioner = Transitioner(animator: SlideAnimator(direction: .fromRightToLeft))
        let nextVC = DetailsViewController()
        let navC = CustomTransitionableNavigationController(rootViewController: nextVC)
        navC.setTransitioner(transitioner)
        present(navC, animated: true)
    }
}
