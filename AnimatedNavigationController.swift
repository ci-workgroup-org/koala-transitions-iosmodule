//
//  AnimatedNavigationController.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

/// UINavigationController subclass that becomes it's own delegate to provide
/// custom transitions
public class AnimatedNavigationController: UINavigationController, CustomTransitions {
    public var transitioner: Transitioner? {
        didSet {
            self.delegate = transitioner
        }
    }
}
