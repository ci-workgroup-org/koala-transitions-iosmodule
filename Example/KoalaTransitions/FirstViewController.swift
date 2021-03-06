//
//  FirstViewController.swift
//  KoalaTransitions_Example
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import KoalaTransitions
import SnapKit
import SwiftyButton
import UIKit

class FirstViewController: UIViewController, CustomTransitionable {
    var transitioner: Transitioner?
    let button = PressableButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = [.lightText, .orange, .blue].randomElement()

        let label = Label()
        label.text = transitioner.debugDescription
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

    @objc func pressed() {
        let nextVC = FirstViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
