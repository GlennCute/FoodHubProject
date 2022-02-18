//
//  ChatController.swift
//  FoodHub
//
//  Created by OPSolutions on 2/9/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var chatTbl: UITableView!
    var display: [String] = ["Joshua Magbuo", "Miguel Aguila", "Jhayvee Ercia"]
    var chatMessage: [String] = ["Hi Kamusta", "Kaya natin to"]
    var userArray: [String] = []
    var message = "This is to inform you that you need to pay your current balance to give you more extra ordinary best experience while browsing or surfing website using our fiber plan."
    let firestoreDatabase = Firestore.firestore()
    var userDocID: String = ""
    var outputData: [String:Any] = [:]
    let loginEmail = UserDefaults.standard.string(forKey: Constants().loginEmailKey)
    let userID = UserDefaults.standard.string(forKey: Constants().userIdKey)
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
        getMessageRoom()
        chatTbl.delegate = self
        chatTbl.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chatTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             print("Deleting: \(display[indexPath.row])")
             deleteToDatabase(user: display[indexPath.row])
             display.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
         }
     }
    func deleteToDatabase(user: String) {
        print("Deleted: \(user)")
    }
    
    @IBAction func newMessage(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        print("you tapped me !!!")
    }
    
    func getUserDocID(){
        let docRef = firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: !)
        docRef.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot.documents{
                self.userDocID = document.documentID
            }
            self.getJoinedRooms()
        }
    }
    
    func getJoinedRooms(){
        let docRef = firestoreDatabase.collection("MessageRoom").document(userDocID)
        docRef.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = snapshot.data() else { return }
            let rooms = data["rooms"] as! [String]
            self.setJoinedRooms(joinedRooms: rooms)
        }
    }
    
    func setJoinedRooms(joinedRooms: [String]){
        for i in 0...(joinedRooms.count - 1){
            UserDefaults.standard.set(true, forKey: joinedRooms[i])
            print(joinedRooms[i])
        }
    }

    func getMessageRoom() {

            guard let uid = Auth.auth().currentUser?.uid else { return }

            let database = Firestore.firestore()

            let reference = database.collection("MessageRoom").document(uid)

            reference.getDocument { querySnapshot, error in

                guard let snapshot = querySnapshot, error == nil else { return }

                guard let data = snapshot.data() else{

                    print("No data")

                    return
                    
                }//guard let data

                if data["rooms"] != nil {

                    let messageRoomID = data["rooms"] as! [String]

                    self.userArray = messageRoomID

                    print(self.userArray)

                    self.chatTbl.reloadData()

                }else{

                    print("no room")

                }//if-else

            }//reference.getDocument

        }//getMessageRoom
}

extension ChatController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
        tableView.deselectRow(at: indexPath, animated: true)
        
                let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
                let detailVC = storyboard.instantiateViewController(withIdentifier: "readMessageVC") as! readMessageVC
//                detailVC.modalPresentationStyle = .overFullScreen //or .overFullScreen for transparency
//                detailVC.img = UIImage(named: userArray[indexPath.row])! //for profile picture
//        let userID = userArray[indexPath.row]
                let messageRoomID = userArray[indexPath.row]
                detailVC.messageRoomID = messageRoomID
                detailVC.contactName = userArray[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.47
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NamesTVC
//        cell.textLabel?.text = "\(items[indexPath.row])" + "\(Price[indexPath.row])"
        let name = userArray[indexPath.row]
//        let messages = display[indexPath.row]
//        cell.textLabel?.text = display[indexPath.row]
        cell.nameLbl.text = name
        cell.messageLbl.text = message
//        cell.nameImgView.image = UIImage (named: name)
        return cell
    }
}
