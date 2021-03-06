//
//  AnimatedNavigationController.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

/// UINavigationController subclass that becomes it's provide a transitioner for
/// custom transitions only for it's own presentation
public class CustomTransitionableNavigationController: UINavigationController, CustomTransitionable {
    public var transitioner: Transitioner?
}

/// UINavigationController subclass that becomes it's own delegate to provide
/// custom transitions, Transitioner using a Transitioner to controller presentation
open class AnimatedNavigationController: UINavigationController, CustomTransitionable {
    open var transitioner: Transitioner? {
        didSet {
            delegate = transitioner
        }
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// UINavigationController subclass that becomes it's own delegate to provide
/// custom transitions, Transitions in and out are take from the view controller being
/// pushed or popped
open class MultiAnimatedNavigationController: UINavigationController, UINavigationControllerDelegate {
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func navigationController(
        _: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from: UIViewController,
        to: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            if let transitioner = (to as? CustomTransitionable)?.transitioner {
                transitioner.playDirection = .forward
                return transitioner.animator
            }
        } else if operation == .pop {
            if let transitioner = (from as? CustomTransitionable)?.transitioner {
                transitioner.playDirection = .backward
                return transitioner.animator
            }
        }

        return nil
    }
}
