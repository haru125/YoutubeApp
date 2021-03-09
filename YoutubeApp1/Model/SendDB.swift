//
//  SendDB.swift
//  YoutubeApp1
//
//  Created by 太田都寿 on 2021/01/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol DoneSendProfileDelegate {
    func doneSendProfileDelegate(sendCheck:Int)
}

class SendDB{
    var userName = String()
    var imageData = Data()
    var db = Firestore.firestore()
    var doneSendProfileDelegate:DoneSendProfileDelegate?
    var userID = String()
    var urlString = String()
    var videoID = String()
    var publishTime = String()
    var descripsion = String()
    var channnelTitle = String()
    var title = String()
    
    init(){
        
    }
    
    init(userID:String,userName:String,urlString:String,videoID:String,title:String,publishTime:String,descripsion:String,channnelTitle:String){
        self.userID = userID
        self.userName = userName
        self.urlString = urlString
        self.videoID = videoID
        self.title = title
        self.publishTime = publishTime
        self.channnelTitle = channnelTitle
    }
    
    func sendData(userName:String) {
        self.db.collection("Collection").document(userName).collection("collection").document().setData(["userID":self.userID as Any,"userName":self.userName as Any,"urlString":self.urlString as Any,"videoID":self.videoID as Any,"title":self.title as Any,"publishTime":self.publishTime as Any,"channnelTitle":self.channnelTitle as Any,"postDate":Date().timeIntervalSince1970])
        self.db.collection("Users").addDocument(data: ["userName":self.userName])
    }
    
    func sendProfile(userName:String,imageData:Data,profileTextView:String){
        let imageRef = Storage.storage().reference().child("ProfileImageFolder").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                self.db.collection("profile").document(userName).setData(
                    ["userName":userName as Any,"imageURLString":url?.absoluteString as Any,"profileTextView":profileTextView as Any]
                )
                
                self.doneSendProfileDelegate?.doneSendProfileDelegate(sendCheck: 1)
            }
        }
    }
}
