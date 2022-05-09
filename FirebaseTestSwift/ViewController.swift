//
//  ViewController.swift
//  FirebaseTestSwift
//
//  Created by 심지훈 on 2022/05/09.
//

import UIKit
import Firebase
import FirebaseStorage //import하기
import Kingfisher

class ViewController: UIViewController {
    
    // MARK : - Properties
    let imagePickerViewController = UIImagePickerController()
    @IBOutlet weak var loadedImageView: UIImageView!
    
    let storage = Storage.storage() //인스턴스 생성
//    let image = UIImage(named: "password")
    var image: UIImage?
    var recentUploadUrl: String?
    
    // MARK : - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
    }
    
    // MARK : - Action
    @IBAction func imageUpload(_ sender: Any) {
        // 버튼 클릭시 앨범으로
        self.imagePickerViewController.sourceType = .photoLibrary
        self.present(imagePickerViewController, animated: true, completion: nil)
//        upLoadImage(img: UIImage) //원하는 이미지 업로드
        guard let image = image else {
            return
        }
        upLoadImage(image)
    }
    
    @IBAction func imgaeLoad(_ sender: Any) {
        guard let recentUploadUrl = recentUploadUrl else {return}
        loadImage(recentUploadUrl) // 인자로 url 이 들어가야 해
    }
    
    // MARK : - Helpers
    func upLoadImage(_ img: UIImage){
        var data = Data() // 이미지를 Data 방식으로 메모리에 저장
        //지정한 이미지를 포함하는 데이터 개체를 JPEG 형식으로 반환, 0.8은 데이터의 품질 (1에 가까울수록 품질이 높은 것)
        data = img.jpegData(compressionQuality: 0.8)!
        
        //Firebase 저장소에 있는 개체의 메타데이터를 나타내는 클래스, URL, 콘텐츠 유형 및 문제의 개체에 대한 FIRStorage 참조를 검색하는 데 사용
        let metaData = StorageMetadata()
        metaData.contentType = "image/png" //데이터 타입을 image or png 타입
        
        // 이미지를 저장할 경로
        let storagePathFirebase = storage.reference().child("image").child("image_1")
        //        let storagePathFirebase = storage.reference().child("Image_1")
        
        // 이미지 업로드 코드
        storagePathFirebase.putData(data, metadata: metaData){
            (metaData,error) in if let error = error { //실패
                print(error)
                return
            }else{ //성공
                print("성공")
            }
        }
        
        storagePathFirebase.downloadURL{ (url, error) in
            print("업로드 후 이미지 url", url!)
            self.recentUploadUrl = url?.absoluteString // url 타입을 string으로 변환 후 전역변수에 저장
        }
        
    }
    
    func loadImage(_ fromURL: String){
        storage.reference(forURL: fromURL).downloadURL { url, error in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.loadedImageView.image = image
        }
    }
    
    
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image", image)
        
//            upLoadImage(img: imagePicked)
            upLoadImage(image)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}



