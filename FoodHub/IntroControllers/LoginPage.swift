//
//  LoginPage.swift
//  FoodHub
//
//  Created by OPSolutions on 2/4/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class LoginController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    let userDefault = UserDefaults.standard
    let loginEmail = UserDefaults.standard.string(forKey: Constants().loginEmailKey)
    let userEmail = UserDefaults.standard.string(forKey: Constants().userEmailKey)
    let userID = UserDefaults.standard.string(forKey: Constants().userIdKey)

    
    override func viewDidLoad() {
        loginBtn.isEnabled = false
        password.delegate = self
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
    }
    
    @IBAction func login(_ sender: Any) {
        let yourEmail = email.text ?? ""
        UserDefaults.standard.set(yourEmail, forKey: Constants().userEmailKey)
        SignInWithFirebase(email: email.text ?? "", password: password.text ?? "")
        self.dismiss(animated: true, completion: nil)
        
    }
    private func SignInWithFirebase(email: String, password: String){

         Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

             guard authResult != nil  else {

                self.view.makeToast("Email or Password does not match", position: .center)

                 return

             }

             if error != nil {
                print("WARNING ERROR LOGIN")
                 print(error!)

             } else {
                 
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                 UserDefaults.standard.set(uid, forKey: Constants().userIdKey)
                     let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
                     let detailVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                     detailVC.modalPresentationStyle = .fullScreen
                     self.present(detailVC, animated: true, completion: nil)
    
                 print("\nsuccessfully sign in", "\n\nemail: "+email, "\npassword:"+password)//log

             }//2nd if-else

         }//Auth.auth

     }//SignInWithFirebase
    
    func fillAll(){
        
        loginBtn.isEnabled = false
        print("Testing")
    }
}

extension LoginController{
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (password.text != "") {
            loginBtn.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
            self.view.endEditing(true)
            return true
        }
}
