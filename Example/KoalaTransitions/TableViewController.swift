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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "cell \(indexPath.row)"
        cell?.imageView?.image = UIImage(named: "image")

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let imageView = cell.imageView {
            let nextVC = DetailsViewController()
            nextVC.transitioner = Transitioner(animator: MatchedViewExpandFromFrameAnimator(imageView.frameInSuperview, originView: imageView, finalView: nextVC.topView))
            nextVC.setTransitioningDelegateToTransitioner()
            present(nextVC, animated: true)
        }
    }
}
