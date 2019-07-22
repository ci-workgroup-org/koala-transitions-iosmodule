//
//  TableViewController.swift
//  KoalaTransitions_Example
//
//  Created by Nicholas Trienens on 5/17/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import KoalaTransitions
import SnapKit

class Cell: UITableViewCell {
    func setRow(_ row: Int) {
        textLabel?.text = "cell \(row)"
        imageView?.image = UIImage(named: "image")
    }
}

class TableViewController: UIViewController, CustomTransitionable, UITableViewDelegate, UITableViewDataSource {
    var transitioner: Transitioner?

    let tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell else {
            #if DEBUG
                fatalError("could not dequeue a `Cell` with Identifier `cell`")
            #endif
            return UITableViewCell()
        }
        cell.setRow(indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let imageView = cell.imageView {
            if indexPath.row.isMultiple(of: 2) {
                let nextVC = ExpandingExample.DetailsViewController()
                let transitioner = Transitioner(animator: ExpandFromFrameAnimator(imageView.frameInSuperview))
                nextVC.setTransitioner(transitioner)
                present(nextVC, animated: true)
            } else {
                let nextVC = ExpandingExample.DetailsViewController()
                nextVC.setTransitioner(Transitioner(animator: MatchedViewExpandFromFrameAnimator(
                    imageView.frameInSuperview,
                    originView: imageView,
                    originSnapshot: nextVC.topView.snapshot(),
                    finalView: nextVC.topView
                )))
                present(nextVC, animated: true)
            }
        }
    }
}

/// safely access an array
extension Array {
    // Optional
    func element(at index: Int) -> Element? {
        guard index < count, index >= 0 else { return nil }
        return self[index]
    }

    // Optional using a constrained input type
    func element(at index: UInt) -> Element? {
        guard index < count else { return nil }
        return self[Int(index)]
    }

    /// Throwing
    enum Error: Swift.Error {
        case indexOutOfBounds
    }

    func element(at index: Int) throws -> Element {
        guard index < count, index >= 0 else { throw Error.indexOutOfBounds }
        return self[index]
    }
}
