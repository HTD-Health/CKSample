//
//  MainTabBarController.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 22/12/2017.
//  Copyright © 2017 Aleksander Maj. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(String(describing: view))
    }
}
