//
//  DetailsViewController.swift
//  KoalaTransitions_Example
//
//  Created by boulder on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import KoalaTransitions
import UIKit

class DetailsViewController: UIViewController {
    var transitioner: Transitioner?

    let topView = UIView()
    let bottomLeftView = UIView()
    let bottomRightView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))

        view.addSubview(topView)
        topView.backgroundColor = .blue
        view.addSubview(bottomLeftView)
        bottomLeftView.backgroundColor = .red
        view.addSubview(bottomRightView)
        bottomRightView.backgroundColor = .orange

        topView.snp.makeConstraints { make in
            make.leading.top.leading.equalToSuperview()
            make.height.equalTo(250)
        }
        bottomLeftView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.width.equalTo(bottomRightView.snp.width)
        }
        bottomRightView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(bottomLeftView)
            make.leading.equalTo(bottomLeftView.snp.trailing)
        }
    }

    @objc func actionClose(_: UITapGestureRecognizer) {
        // presentingViewController?.transitioningDelegate = transitioner
        transitioner?.playDirection = .backward
        transitioningDelegate = transitioner
        presentingViewController?.dismiss(animated: true)
    }
}
