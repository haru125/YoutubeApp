//
//  ProfileViewController.swift
//  YoutubeApp1
//
//  Created by 太田都寿 on 2021/01/21.
//

import UIKit
import Photos
import FirebaseFirestore

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DoneSendProfileDelegate {

    var userName = String()
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        button.layer.cornerRadius = 10
    }
    
    @IBAction func tap(_ sender: Any) {
        showAlert()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    
    func checkCamera(){
        
        // ユーザーに許可を促す.
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch(status){
            case .authorized:
                print("Authorized")
                
            case .denied:
                print("Denied")
                
            case .notDetermined:
                print("NotDetermined")
                
            case .restricted:
                print("Restricted")
            case .limited:
                print("limited")
            @unknown default: break
                
            }
            
        }
        
    }
   
    func showAlert(){
           let alert: UIAlertController = UIAlertController(title: "選択してください。", message: "カメラアルバムどちらにしますか？", preferredStyle:  .alert)

           // カメラボタン
           let cameraAction: UIAlertAction = UIAlertAction(title: "カメラ", style: .default, handler:{
               // ボタンが押された時の処理を書く（クロージャ実装）
               (action: UIAlertAction!) -> Void in
               
               
               
               self.createImagePicker(sourceType: .camera)
           })
           // アルバムボタン
           let albumAction: UIAlertAction = UIAlertAction(title: "アルバム", style: .default, handler:{
               // ボタンが押された時の処理を書く（クロージャ実装）
               (action: UIAlertAction!) -> Void in
               self.createImagePicker(sourceType: .photoLibrary)

           })
           
           let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)

           // ③ UIAlertControllerにActionを追加
           alert.addAction(albumAction)
           alert.addAction(cameraAction)
           alert.addAction(cancelAction)

           // ④ Alertを表示
           present(alert, animated: true, completion: nil)
       }
       
    func createImagePicker(sourceType:UIImagePickerController.SourceType){
        // インスタンスの作成
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            
            imageView.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
            
        }
    
    }


    @IBAction func done(_ sender: Any) {
        let sendDB = SendDB()
        sendDB.doneSendProfileDelegate = self
        sendDB.sendProfile(userName: userName, imageData: imageView.image!.jpegData(compressionQuality: 0.5)!, profileTextView: textView.text!)
    }
    
    func doneSendProfileDelegate(sendCheck: Int) {
        if sendCheck == 1{
            let searchVC = self.storyboard?.instantiateViewController(identifier: "searchVC") as! SearchViewController
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    
}
