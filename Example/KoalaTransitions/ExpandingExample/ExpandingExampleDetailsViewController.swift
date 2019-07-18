//
//  AnimatedNavigationController.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import KoalaTransitions
import UIKit

extension ExpandingExample {
    enum DetailsAnimatableElements: Int, Equatable, Matchable, CaseIterable {
        case topView
        case leftView
    }

    class DetailsViewController: UIViewController, CustomTransitionable, ElementMatching {
        func elementsForAnimtion() -> [ElementInterface] {
            let views: [ElementInterface] = [
                Element<DetailsAnimatableElements>(view: topView, use: .topView),
                Element<DetailsAnimatableElements>(view: bottomLeftView, use: .leftView)
            ]
            return views
        }

        var transitioner: Transitioner?

        let topView = UIImageView(image: UIImage(named: "image"))
        let bottomLeftView = UIView() // UIImageView(image: UIImage(named: "image"))
        let bottomRightView = UIView()
        let text = Label()

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

            view.addSubview(text)

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
                make.height.greaterThanOrEqualTo(250)
                make.width.greaterThanOrEqualTo(150)
            }

            text.snp.makeConstraints { make in
                make.trailing.leading.bottom.equalToSuperview().inset(50)
                make.top.equalTo(topView.snp.bottom).offset(30)
            }
            text.text = """
                        Many times, readers will get distracted by readable text when looking at the layout of a page. Instead of using filler text that says “Insert content here,” Lorem Ipsum uses a normal distribution of letters, making it resemble standard English.
                        
                        This makes it easier for designers to focus on visual elements, as opposed to what the text on a page actually says.
            """
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
}
