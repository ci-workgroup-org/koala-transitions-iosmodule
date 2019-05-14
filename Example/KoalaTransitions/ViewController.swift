//
//  ViewController.swift
//  KoalaTransitions
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
        title = "List"
        // Do any additional setup after loading the view, typically from a nib.

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func pressed() {
        let transitioner = Transitioner(animator: PushNavigationAnimator(direction: .fromRightToLeft))
        let nextVC = DetailsViewController()
        nextVC.transitioner = transitioner
        nextVC.transitioningDelegate = transitioner
        present(nextVC, animated: true)
    }
}
