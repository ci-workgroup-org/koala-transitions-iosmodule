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
    var transitioner: Transitioner?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .orange

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
        print("hi")
        transitioner = Transitioner(animator: ZoomAnimator(button.frameInSuperView()))
        let nextVC = DetailsViewController()
        nextVC.transitioner = transitioner
        nextVC.transitioningDelegate = transitioner
        present(nextVC, animated: true, completion: {
            print(self.transitioner)
        })
    }
}
