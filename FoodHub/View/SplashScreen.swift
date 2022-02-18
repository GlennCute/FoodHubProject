//
//  SplashScreen.swift
//  FoodHub
//
//  Created by OPSolutions on 2/3/22.
//

import Foundation
import UIKit

class SplashScreen: UIViewController {
    
    var timeLeft = 3
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        initTimer()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func initTimer() {
        let userID = UserDefaults.standard.string(forKey: Constants().userEmailKey)
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    self.timeLeft -= 1
                    print("Time Left \(self.timeLeft)")
                    if(self.timeLeft==0){
                        timer.invalidate()
                        self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
                        
                        if(userID == "True") {
                            
                        let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
                        let detailVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                            self.navigationController?.pushViewController(detailVC, animated: true)
                    } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let detailVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
    }
    
}
    }
}
