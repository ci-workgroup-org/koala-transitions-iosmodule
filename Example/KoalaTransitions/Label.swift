//
//  Label.swift
//  KoalaTransitions_Example
//
//  Created by Nicholas Trienens on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class Label: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        font = UIFont.systemFont(ofSize: 20)
        numberOfLines = 3
        textAlignment = .center
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
