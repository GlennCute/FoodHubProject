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

class createMessageVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageField: UITextField!

    
    var message: [MessageData] = [MessageData(text: "Hey Kamusta Ka", isFirstUser: true),MessageData(text: "Oks lang ang hirap ng project men", isFirstUser: false),MessageData(text: "oo nga eh", isFirstUser: true),MessageData(text: "oo nga eh", isFirstUser: false),MessageData(text: "oo nga eh", isFirstUser: true),MessageData(text: "oo nga eh", isFirstUser: false),MessageData(text: "oo nga eh", isFirstUser: true)]
    
//    var outputData: [String:Any] = [:]
    var arrmsg: [[String]] = []
    let userID = UserDefaults.standard.string(forKey: Constants().userIdKey)
    let loginEmail = UserDefaults.standard.string(forKey: Constants().loginEmailKey)!
    var roomMembers: [String] = []
    var roomMembersDocID: [String] = []
    var img = UIImage()
    var userDocID: String = ""
    var contactName = ""
    var messageRoomID = ""
    var contactEmail: [String] = []
    var isFirstUser: Bool = true
    let firestoreDatabase = Firestore.firestore()
    var roomName: String = ""

    
    override func viewDidLoad() {
        print("Thisis contact email \(contactEmail)")
        super.viewDidLoad()
        print(contactName)
        getUserDocID()
        getRoomMembersDocID()
        getRoomName()
        profileName.text = contactName
        chatTable.delegate = self
        chatTable.dataSource = self
        messageField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkRoom()
        let textFromField = messageField.text ?? ""
            message.append(MessageData(text: textFromField, isFirstUser: isFirstUser))
            print ("This is your arrayMessage !!\(arrmsg)")
            chatTable.beginUpdates()
            chatTable.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0 )], with: .fade)
            chatTable.endUpdates()
            chatTable.scrollToRow(at: IndexPath.init(row: message.count - 1, section: 0) , at: .top, animated: true)
        isFirstUser = !isFirstUser
//        messageField.text = nil
//            checkRoom()
        return true
    }
    
    func getUserDocID(){
        let docRef = firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: loginEmail)
        docRef.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot.documents{
                self.userDocID = document.documentID
            }
        }
    }
    
    func getRoomMembersDocID(){
        for i in 0...(roomMembers.count - 1){
            let docRef = firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: roomMembers[i])
            docRef.getDocuments { querySnapshot, error in
                guard let snapshot = querySnapshot, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                for document in snapshot.documents{
                    self.roomMembersDocID.append(document.documentID)
                }
            }
        }
    }
    
    func getRoomName(){
        for i in 0...(roomMembers.count - 1){
            roomName = roomName + roomMembers[i] + "_"
        }
    }
    
    func checkRoom(){
        let roomName = roomName
        if UserDefaults.standard.bool(forKey: roomName) == true {
            print("conversation exists, proceed with sending message")
            getMessage(roomName: roomName)
            print("This is your room \(roomName)")
        }
        
        else{
            print("no conversation exists, create new conversation")
            UserDefaults.standard.set(true, forKey: roomName)
            UserDefaults.standard.synchronize()
            newRoomSetup(roomName: roomName)
            
        }
    }
    
    fileprivate func newRoomSetup(roomName: String) {
        for i in 0...(roomMembersDocID.count - 1){
            let docRef = firestoreDatabase.collection("MessageRoom").document(roomMembersDocID[i])
            updateMessageRoom(docRef: docRef, roomName: roomName)
        }
        
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        createRoom(docRefRoom: docRefRoom, roomName: roomName)
    }
    
    fileprivate func updateMessageRoom(docRef: DocumentReference, roomName: String) {
        docRef.getDocument { document, error in
            guard let doc = document, error == nil else { return }
            if doc.exists{
                var rooms = doc["rooms"] as! [String]
                rooms.append(roomName)
                docRef.setData(["rooms":rooms], merge: true, completion: nil)
            } else {
                var rooms: [String:[String]] = [:]
                rooms["rooms"] = []
                rooms["rooms"]!.append(roomName)
                docRef.setData(rooms, merge: true, completion: nil)
            }
        }
    }
    
    fileprivate func createRoom(docRefRoom: DocumentReference, roomName: String) {
        docRefRoom.setData(["roomMembers": self.contactEmail])
        getMessage(roomName: roomName)
    }
    
    fileprivate func getMessage(roomName: String){
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        docRefRoom.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else { return }
            guard let data = snapshot.data() else{
                print("no data")
                return
            }
            print(data["messages"] ?? "data[messages] is nil")
            
            if data["messages"] != nil {
                var messages = data["messages"] as! [String:[String]]
                let count = messages.count
                let date = Date()
                var timeStamp = ""
                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = ("MM/dd/yyyyHH:mm:ss")
                timeStamp = formatter.string(from: date)
                let message = self.messageField.text ?? " "
                messages["message\(count)"] = [message,timeStamp,self.userDocID]
                self.sendMessage(messages: messages)
            }
            else {
                var messages: [String:[String]] = [:]
                let date = Date()
                var timeStamp = ""
                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = ("MM/dd/yyyyHH:mm:ss")
                timeStamp = formatter.string(from: date)
                let message = self.messageField.text ?? " "
                messages["message0"] = [message,timeStamp,self.userDocID]
                self.sendMessage(messages: messages)
            }
        }
    }
    
    
    fileprivate func sendMessage(messages: [String:[String]]) {
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        docRefRoom.updateData(["messages":messages])
        clearTextField()
    }
    
    fileprivate func clearTextField(){
        messageField.text = ""
        messageField.resignFirstResponder()
    }
    
     func getMessage1(){
        let docRefRoom = firestoreDatabase.collection("Room").document("Glenn.diaz@opsolutions.biz_ercia@gmail.com_joshua@gmail.com_miguel.aguila01@gmail.com_")
        docRefRoom.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else { return }
            guard let data = snapshot.data() else{
                print("no data")
                return
            }
            print(data["messages"] ?? "data[messages] is nil")
            
            if data["messages"] != nil {
                var messages = data["messages"] as! [String:[String]]
                let count = messages.count
                let date = Date()
                var timeStamp = ""
                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = ("MM/dd/yyyyHH:mm:ss")
                timeStamp = formatter.string(from: date)
                let message = self.messageField.text ?? " "
                messages["message\(count)"] = [message,timeStamp,self.userDocID]
                self.sendMessage(messages: messages)
            }
            else {
                var messages: [String:[String]] = [:]
                let date = Date()
                var timeStamp = ""
                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = ("MM/dd/yyyyHH:mm:ss")
                timeStamp = formatter.string(from: date)
                let message = self.messageField.text ?? " "
                messages["message0"] = [message,timeStamp,self.userDocID]
                self.sendMessage(messages: messages)
            }
        }
    }
//
//    @IBAction func send(_ sender: Any) {
//        checkRoom()
//        guard let textFromField = messageField.text else{return}
//        if textFromField != ""{
//            message.append(MessageData(text: textFromField, isFirstUser: isFirstUser))
//            print ("This is your arrayMessage !!\(arrmsg)")
//            chatTable.beginUpdates()
//            chatTable.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0 )], with: .fade)
//            chatTable.endUpdates()
//            chatTable.scrollToRow(at: IndexPath.init(row: message.count - 1, section: 0) , at: .top, animated: true)
//        isFirstUser = !isFirstUser
////        messageField.text = nil
////            checkRoom()
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
        
        cell.updateMessageCell(by: message[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}



