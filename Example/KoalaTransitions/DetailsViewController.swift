//
//  DetailsViewController.swift
//  KoalaTransitions_Example
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import Foundation
import KoalaTransitions
import UIKit

class DetailsViewController: UIViewController, CustomTransitionable {
    var transitioner: Transitioner?

    let topView = UIImageView(image: UIImage(named: "image"))
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

        topView.contentMode = .scaleToFill
        topView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
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
        dismiss(animated: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) -> Void in

            let orient = UIApplication.shared.statusBarOrientation

            switch orient {
            case .portrait:
                print("Portrait")
            // Do something
            default:
                print("Anything But Portrait")
                // Do something else
            }

        }, completion: { (_) -> Void in
            print("rotation completed")
        })

        super.viewWillTransition(to: size, with: coordinator)
    }
}
