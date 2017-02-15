//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Marty Avedon on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//
import UIKit
import SnapKit
import JSSAlertView
import AVKit
import AVFoundation
import MobileCoreServices
import PhotosUI
import FirebaseAuth
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // parts from graffy and last assessment
    
    let currentUser = FIRAuth.auth()?.currentUser
    let categoryReference = FIRDatabase.database().reference()
    let databaseReference = FIRDatabase.database().reference().child("Users")
    var picToUpload: UIImage?
    var arrOfAssetURLString = [String]()
    var nameAssignedToPicture: String?
    var storage: FIRStorageReference!
    var currentIndex: CGFloat!
    var key: String? = nil
    var results = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        descriptTextField.delegate = self
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        setupViewHeirarchy()
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser == nil {
            uploadButton.isEnabled = false
        } else {
            uploadButton.isEnabled = true
        }
    }
    
    // MARK: - TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField.text != "" {
            nameAssignedToPicture = text
        }
    }
    
    // MARK: - Actions
    
    func uploadAction(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let theyPicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.picToUpload = theyPicked
            pic.contentMode = .scaleAspectFill
            self.pic.image = self.picToUpload
            uploadPic(pic: theyPicked)
            //savePic()
        }
        
        // dismissing imagePickerController
        dismiss(animated: true)
    }
    
    func uploadPic(pic: UIImage) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(pic) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print (error)
                    return
                }
                
                self.nameAssignedToPicture = imageName
                showAlert("Photo uploaded!", presentOn: self)
            })
        }
    }
    
//        func savePic() {
//            if let nameOfPic = nameAssignedToPicture {
//                let filePath = "Storage test/"
//                let stringasURL = URL(string: nameOfPic)
//    
//                self.storage.child(filePath).putFile(stringasURL!, metadata: nil) { (metadata, error) in
//                    if let error = error {
//                        showAlert("We couldn't upload your picture at this time!", presentOn: self)
//                        print("Error uploading: \(error)")
//    
//                        return
//                    }
//    
//                    self.key = self.databaseReference.childByAutoId().key
//    
//                    if let currentUsersUid = FIRAuth.auth()?.currentUser?.uid {
//                        let values = ["Picture \(self.key!)": metadata?.downloadURL()?.absoluteString]
//                        let userReference = self.databaseReference.child(currentUsersUid).child("uploads")
//    
//                        self.categoryReference.updateChildValues(values)
//    
//                        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                            if err != nil {
//                                showAlert("We couldn't upload your picture at this time!", presentOn: self)
//                                print(err!)
//    
//                                return
//                            }
//                        })
//                    }
//                }
//            }
//    }
//    }

    // Mark: - Constraints & Things
    
    func configureConstraints() {
        pic.snp.makeConstraints { (view) in
            view.leading.trailing.equalToSuperview()
            view.top.equalToSuperview().offset(30)
            view.width.equalTo(375)
            view.height.equalTo(pic.snp.width)
        }
        
        uploadSomething.snp.makeConstraints{ (view) in
            view.center.equalTo(pic.snp.center)
        }
        
        uploadButton.snp.makeConstraints{ (view) in
            view.center.equalTo(pic.snp.center)
            view.width.equalTo(pic.snp.width)
            view.height.equalTo(pic.snp.height)
        }
        
        descriptTextField.snp.makeConstraints { (textField) in
            textField.leading.equalToSuperview().offset(8.0)
            textField.trailing.equalToSuperview().inset(8.0)
            textField.top.equalTo(pic.snp.bottom).offset(8.0)
            textField.bottom.equalToSuperview()
        }
    }
    
    func setupViewHeirarchy() {
        self.view.addSubview(descriptTextField)
        self.view.addSubview(pic)
        self.view.addSubview(uploadSomething)
        self.view.addSubview(uploadButton)
    }
    
    // MARK: - Views initialized down here!
    
    internal lazy var descriptTextField: UITextField = {
        let textField: UITextField = UITextField(frame: .zero)
        
        textField.placeholder = "Add a description..."
        textField.returnKeyType = .done
        
        return textField
    }()
    
    internal lazy var pic: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        
        return imageView
    }()
    
    internal lazy var uploadSomething: UILabel = {
        let label: UILabel = UILabel()
        
        label.backgroundColor = .lightGray
        
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    
    lazy var uploadButton:  UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        
        button.addTarget(self, action: #selector(uploadAction(sender:)), for: .touchUpInside)
        
        button.backgroundColor = .green
        button.alpha = 0.2
        
        return button
    }()
}
