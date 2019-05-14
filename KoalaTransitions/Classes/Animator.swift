//
//  Animator.swift
//  KoalaTransitions
//
//  Created by boulder on 5/13/19.
//

import Foundation
import UIKit

public protocol Animator: UIViewControllerAnimatedTransitioning {
    var reversed: Bool { get set }
}
