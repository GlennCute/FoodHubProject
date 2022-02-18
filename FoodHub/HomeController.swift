//
//  HomeController.swift
//  FoodHub
//
//  Created by OPSolutions on 2/9/22.
//

import UIKit

class HomeController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ito yon")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
                title = ""
//        title = "Explore"
//        navigationController?.navigationBar.prefersLargeTitles = true

    }

}
