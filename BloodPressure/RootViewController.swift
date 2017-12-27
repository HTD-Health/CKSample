//
//  RootViewController.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 22/12/2017.
//  Copyright © 2017 Aleksander Maj. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainTabVC = MainTabBarController()
        embed(viewController: mainTabVC)
    }
}

extension RootViewController {
    func embed(viewController childVC: UIViewController) {
        addChildViewController(childVC)
        self.containerView.addSubview(childVC.view)
        let childFrame = self.containerView.bounds
        childVC.view.frame = childFrame
        childVC.didMove(toParentViewController: self)
    }
}
