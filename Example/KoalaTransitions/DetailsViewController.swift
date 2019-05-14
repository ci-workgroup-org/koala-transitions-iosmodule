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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .green

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
    }

    @objc func actionClose(_: UITapGestureRecognizer) {
        // presentingViewController?.transitioningDelegate = transitioner
        transitioningDelegate = transitioner
        presentingViewController?.dismiss(animated: true, completion: {
            print(self.transitioner)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
