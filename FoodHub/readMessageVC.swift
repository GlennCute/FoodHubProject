//
//  createMessageVC.swift
//  FoodHub
//
//  Created by OPSolutions on 2/15/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import Toast_Swift

class readMessageVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var message: [MessageData] = [MessageData(text: "Hey Kamusta Ka", isFirstUser: true),MessageData(text: "Oks lang ang hirap ng project men", isFirstUser: false),MessageData(text: "oo nga eh", isFirstUser: true),MessageData(text: "oo nga eh", isFirstUser: false),MessageData(text: "oo nga eh", isFirstUser: true),MessageData(text: "oo nga eh", isFirstUser: false),MessageData(text: "oo nga eh", isFirstUser: true)]
//    var outputData: [String:Any] = [:]
    var arrmsg: [[String]] = []
    let userID = UserDefaults.standard.string(forKey: Constants().userIdKey)
    
    var messageValueArray: [[String]] = []
    var roomName: String = ""
    var img = UIImage()
    var contactName = ""
    var messageRoomID = ""
    var messagesArray: [String:[String]] = [:]
    var isFirstUser: Bool = true
    let firestoreDatabase = Firestore.firestore()
    var messages: [String:Any] = [:]
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        getLatestMessage()
        profileName.text = contactName
        chatTable.delegate = self
        chatTable.dataSource = self
        messageTextField.delegate = self
//        setupView()

    }
    
    
//    func getDataFromDatabase(){
//        let firestoreDatabase = Firestore.firestore()
//        let docRef = firestoreDatabase.collection("Room").document(userID!)
//
//            docRef.getDocument{ snapshot, error in
//
//                guard let data = snapshot?.data(), error == nil else{
//
//                    NSLog("\(String(describing: error))")
//
//                    return
//
//                }
//                self.messages = data
//                self.setupView()
//                NSLog("\(String(describing: self.messages))")
//                }
//    }
    
    func sendNewMessage(){

            self.getLatestMessage()

            let reference = Firestore.firestore().collection("Room").document(messageRoomID)

            reference.getDocument { (document, error) in

                if let document = document {

                    if document.exists{

                        reference.updateData(["messages":self.messagesArray]){ err in

                            if let err = err {

                                print("Error writing document: \(err)")

                            }else{

                                print("\nmessage sent!")

                                self.messageTextField.text?.removeAll()

                            }//if-let err = err

                        }//reference.updateData

                    }//if document.exist //if not existing create new document here

                }//if-let document

            }//reference.getDocument

        }//sendNewMessage
    
//    func setupView(){
//        let allMessages = messages["messages"]
//        print("This is all of the messages \(String(describing: allMessages))")
//        chatTable.reloadData()
//    }
    
//    func setupListener() -> ListenerRegistration{
//
//        let db = firestoreDatabase
//        let listener = db.collection("Room").document(roomName).addSnapshotListener{
//            DocumentSnapshot, error in
//            guard let document = DocumentSnapshot else{
//                print("Error fetching document: \(error!)")
//                return
//            }
//            guard let data = document.data() else{
//                print("Document data was empty.")
//                return
//            }
//            self.messagesArray = []
//            let messages = data["messages"] as! [String:[String]]
//            for i in 0...(messages.count - 1){
//                self.messagesArray.append(messages["message\(i)"]!)
//            }
//            self.chatTable.reloadData()
//        }
//        return listener
//
//    }


        func getLatestMessage(){
//            let userEmail = UserDefaults.standard.string(forKey: Constants().loginEmailKey)
//            guard let uid = Auth.auth().currentUser?.uid else { return }

            let reference = Firestore.firestore().collection("Room").document(messageRoomID)

            reference.getDocument { querySnapshot, error in

                guard let snapshot = querySnapshot, error == nil else { return }

                guard let data = snapshot.data() else{

                    print("No data")

                    return

                }//guard let data

                print("\nStored Messages: ",data["messages"] as Any)

//                if data["messages"] != nil {

                    var messages = data["messages"] as! [String:[String]]
                
                self.messageValueArray = []
                for i in 0...(messages.count - 1){
                    self.messageValueArray.append(messages["message\(i)"]!)
                }
                print("Awitizekieeee !!!!\(self.messageValueArray)")
                    let date = Date()
                    var timeStamp = ""
                    let formatter = DateFormatter()
                    formatter.timeZone = .current
                    formatter.locale = .current
                    formatter.dateFormat = ("MM/dd/yyyyHH:mm:ss")
                    timeStamp = formatter.string(from: date)

                    messages["message\(messages.count)"] = [self.messageTextField.text ?? "",timeStamp,"Glenn G. Diaz Jr."]

                    self.messagesArray = messages

                    print("Ito yung latest ? \(self.messageValueArray as Any)")

//                }
//                    else{
//
//                    let date = Date()
//                    var timeStamp = ""
//                    let formatter = DateFormatter()
//                    formatter.timeZone = .current
//                    formatter.locale = .current
//                    formatter.dateFormat = ("MM/dd/yyyyHH:mm:ss")
//                    timeStamp = formatter.string(from: date)
//
//                    self.messagesArray = ["message0":[self.messageTextField.text ?? "",timeStamp,"Glenn Diaz Jr."]]
//
//                    print("Or Ito ??? \(self.messagesArray as Any)")
//
//                }//if-else

            }//reference.getDocument

        }//getLatestMessage
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendNewMessage()
        let textFromField = messageTextField.text ?? ""
        if textFromField != ""{
            message.append(MessageData(text: textFromField, isFirstUser: isFirstUser))
            print ("This is your arrayMessage !!\(arrmsg)")
            chatTable.beginUpdates()
            chatTable.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0 )], with: .fade)
            chatTable.endUpdates()
            chatTable.scrollToRow(at: IndexPath.init(row: message.count - 1, section: 0) , at: .top, animated: true)
        isFirstUser = true

        }
        return true
    }

//    @IBAction func send(_ sender: Any) {
//        sendNewMessage()
//        guard let textFromField = messageTextField.text else{return}
//        if textFromField != ""{
//            message.append(MessageData(text: textFromField, isFirstUser: isFirstUser))
//            print ("This is your arrayMessage !!\(arrmsg)")
//            chatTable.beginUpdates()
//            chatTable.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0 )], with: .fade)
//            chatTable.endUpdates()
//            chatTable.scrollToRow(at: IndexPath.init(row: message.count - 1, section: 0) , at: .top, animated: true)
//        isFirstUser = !isFirstUser
//
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell

//        let messageValue = messageValueArray[indexPath.row][0]
//        let fullName = messageValueArray[indexPath.row][2]
        
//        cell.messageLabel.text = fullName
        
        cell.updateMessageCell(by: message[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

