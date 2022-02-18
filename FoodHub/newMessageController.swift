//
//  newMessageController.swift
//  FoodHub
//
//  Created by OPSolutions on 2/14/22.
//

import UIKit
import FirebaseFirestore

class newMessageController: UIViewController, UITableViewDelegate {
    let firestoreDatabase = Firestore.firestore()
    var userArray: [String] = []
    var emailArray: [String] = []
    var sendTo: [String] = []
    @IBOutlet weak var namesTbl: UITableView!
    @IBOutlet weak var sendToTextField: UITextField!
    var userList: [[String:Any]] = []
    var docIDList: [String] = []
    var roomMembers: [String] = []
    let loginEmail = UserDefaults.standard.string(forKey: Constants().loginEmailKey)
    let loginName = UserDefaults.standard.string(forKey: Constants().userNamelKey)
    
    override func viewDidLoad() {
        getUsersFromFirebase()
        getUsersInfo()
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated: false)
        namesTbl.delegate = self
        namesTbl.dataSource = self
        namesTbl.separatorStyle = .none
        namesTbl.showsVerticalScrollIndicator = false
        sendToTextField.delegate = self
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        let openNewVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatController") as! ChatController

        self.dismiss(animated: false, completion: { () -> Void   in
               self.navigationController?.pushViewController(openNewVC, animated: true)

                  })
    }

//    @IBAction func ok(_ sender: Any) {
//                let sortedRoomMembers = sortUsers()
//
//                let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
//                let detailVC = storyboard.instantiateViewController(withIdentifier: "createMessageVC") as! createMessageVC
//                detailVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        ////        detailVC.img = UIImage(named: userArray[indexPath.row])! //for profile picture
//                detailVC.roomMembers = sortedRoomMembers
//                detailVC.contactName = sendToTextField.text ?? ""
//                detailVC.contactEmail = roomMembers
//                self.navigationController?.pushViewController(detailVC, animated: true)
//    }
    
    
    func getUsersInfo()

        {
            let database = Firestore.firestore()

            let contactdataRef = database.collection("UserInfo")

            contactdataRef.getDocuments() { (querySnapshot, err) in

                if let err = err {

                    print("Error getting documents: \(err)")

                } else {

                    for document in querySnapshot!.documents {

                       // let docId = document.documentID

                        let firstName = document.get("firstName") as! String

                        let lastName = document.get("lastName") as! String
                        
                        let email = document.get("email") as! String

                        self.userArray.append(firstName + " " + lastName)
                        
                        self.emailArray.append(email)
                        UserDefaults.standard.set(self.loginName, forKey: Constants().userNamelKey)

                        print("\nData in array:",self.userArray as Any)

                    }//for

                    self.namesTbl.reloadData()

                }//if-else

            }//snapshot

        }//getUsers
    
    func getUsersFromFirebase(){
        let colRef = firestoreDatabase.collection("UserInfo").whereField("email", isNotEqualTo: self.loginEmail ?? "")
        colRef.getDocuments { snapshot, error in
            guard let querySnapshot = snapshot, error == nil else{
                print("getDocuments failed: \(error!.localizedDescription)")
                return
            }
            for document in querySnapshot.documents{
                self.docIDList.append(document.documentID)
                self.userList.append(document.data())
            }
            self.namesTbl.reloadData()
        }
    }
}
    
extension newMessageController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
        
        if roomMembers.contains(userList[indexPath.row]["email"] as! String) == false{
            roomMembers.append(userList[indexPath.row]["email"] as! String)
            sendToTextField.text = sendToTextField.text! +
            (userList[indexPath.row]["email"] as! String) + " "
            sendToTextField.becomeFirstResponder()
        }
        print(self.roomMembers)
        
//        sendTo.append(userArray[indexPath.row])
//        sendToTextField.text = sendToTextField.text! + userArray[indexPath.row]
//        let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
//        let detailVC = storyboard.instantiateViewController(withIdentifier: "createMessageVC") as! createMessageVC
////        detailVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//////        detailVC.img = UIImage(named: userArray[indexPath.row])! //for profile picture
//        detailVC.contactName = sendToTextField.text ?? ""
////        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.47
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docIDList.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchNameTVC
//        cell.textLabel?.text = "\(items[indexPath.row])" + "\(Price[indexPath.row])"
        let name = docIDList[indexPath.row]
//        let messages = display[indexPath.row]
//        cell.textLabel?.text = display[indexPath.row]
        cell.nameLbl.text = name
//        cell.nameImgView.image = UIImage (named: name)
        return cell
    }
}

extension newMessageController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let sortedRoomMembers = sortUsers()
        presentMessageVC(sortedRoomMembers)
        return true
    }
    
    func sortUsers() -> [String]{
        self.roomMembers.append(loginEmail!)
        let sortedRoomMembers = self.roomMembers.sorted()
        return sortedRoomMembers
    }

    fileprivate func presentMessageVC(_ sortedRoomMembers: [String]) {
        let detailVc = UIStoryboard(name: "HomeController", bundle: nil).instantiateViewController(withIdentifier: "createMessageVC") as! createMessageVC
        detailVc.roomMembers = sortedRoomMembers
        detailVc.contactName = sendToTextField.text ?? ""
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}
    

