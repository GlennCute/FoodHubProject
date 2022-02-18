//
//  ViewController.swift
//  FoodHub
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginLogo: UIImageView!
    var user = UserInfo()
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("This is your Name : \(user.firstName) \(user.lastName)")
    }
    
    func setupView(){
        if userDefault.bool(forKey: "isSignedIn") {
        //show main page
            let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            detailVC.modalPresentationStyle = .fullScreen
            self.present(detailVC, animated: true, completion: nil)

        }
    }


}

