//
//  ViewController.swift
//  YoutubeApp1
//
//  Created by 太田都寿 on 2021/01/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 10
    }

    @IBAction func createNewUser(_ sender: Any) {
        createUser()
    }
    
    func createUser(){
        Auth.auth().signInAnonymously { (result, error) in
            let user = result?.user
            print(user.debugDescription)
            UserDefaults.standard.set(self.textfield.text, forKey: "userName")
            let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
            profileVC.userName = self.textfield.text!
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

