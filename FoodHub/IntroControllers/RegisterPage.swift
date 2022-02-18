//
//  RegisterPage.swift
//  FoodHub
//
//  Created by OPSolutions on 2/4/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import Toast_Swift

class RegisterController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var houseNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var postal: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var user = UserInfo()
    let firestoreDatabase = Firestore.firestore()

    override func viewDidLoad() {
        
        registerBtn.isEnabled = false
        confirmPassword.delegate = self
        confirmPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAddress()
        print("This is your streetname:\(user.streetName)")
        print("This is your district: \(user.district)")
    }
    
    @IBAction func register(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "ARE YOU SURE YOU WANT TO CREATE THIS ACCOUNT ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {_ in
            self.signUpWithFireBase()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension RegisterController{
    
    func updateUserInfo(){
        user.firstName = firstName.text ?? ""
        user.lastName = lastName.text ?? ""
        user.email = Email.text ?? ""
        user.password = password.text ?? ""
        user.houseNumber = houseNumber.text ?? ""
        user.streetName = street.text ?? ""
        user.district = district.text ?? ""
        user.postalCode = postal.text ?? ""
        user.city = city.text ?? ""

    }
    
    func signUpWithFireBase(){
        
        updateUserInfo()
        Auth.auth().createUser(withEmail: Email.text!, password: password.text!, completion: { result, error in
            if error != nil{
                NSLog("\(String(describing: error))")
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let docRef = self.firestoreDatabase.collection("UserInfo").document(uid)

            docRef.setData(["firstName": self.user.firstName, "email": self.user.email, "streetNumber": self.user.streetNumber, "lastName": self.user.lastName, "houseNumber": self.user.houseNumber, "streetName": self.user.streetName, "district": self.user.district, "postalCode": self.user.postalCode, "city": self.user.city, "latitude": self.user.latitude, "longitude": self.user.longitude ])
        })
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (password.text != "") {
            if (password.text == confirmPassword.text) {
                registerBtn.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
            self.view.endEditing(true)
            return true
        }
    
    func getAddress(){
        houseNumber.text = user.streetNumber
        street.text = user.streetName
        district.text = user.district
        postal.text = user.postalCode
        city.text = user.city
    }
}
