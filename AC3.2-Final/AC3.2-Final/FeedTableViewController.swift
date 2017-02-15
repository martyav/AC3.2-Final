//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Marty Avedon on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class FeedTableViewController: UITableViewController {
    // this vc is a frankenstein of graffy, the review, the breaking bad project, and the emoji card project
    
    let cellReuseIdentifier = "feedCell"
    let databaseReference = FIRDatabase.database().reference().child("Users")
    var storage = FIRStorageReference()
    var selectedCategory: String!
    var pictureURLS: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getPics()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifier)
        
        storage = FIRStorage.storage().reference(forURL: "gs://jason-project-65494.appspot.com")
        
        let userPostRef = self.databaseReference.child("imageURL")
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let userReference = self.databaseReference.child(uid)
        
        userReference.child("imageUrl").observe(.value, with: { (snapShot) in
            if let urlString = snapShot.value as? String {
                //self.pictureURLS.downloadImage(from: urlString, with: nil)
            }
        })
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \(pictureURLS)")
        
        self.tableView.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPics()
    }
    
    func getPics() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var newPics: [String] = []
            
            for child in snapshot.children {
                dump(child)
                
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String:String] {
                    let picString = valueDict["imageUrl"] ?? ""
                    newPics.append(picString)
                }
            }
            
            self.pictureURLS = newPics
            self.tableView.reloadData()
        })
        print("????????????????????????????????????????????????\(pictureURLS)")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let uploadedPics = pictureURLS {
            return uploadedPics.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FeedTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let uploadedPics = pictureURLS {
            let picURL = uploadedPics[indexPath.row]
            
            DataManager.dataManager.getImage(fromUrl: picURL) { (image) in
                if let validImage = image {
                    DispatchQueue.main.async {
                        cell.imageView?.image = validImage
                        cell.descript?.text = "efwegaergawerbhesber gw g w g aeg wa gf wq f wrbv er vw agv"
                        self.tableView.reloadInputViews()
                    }
                }
            }
        }
        
        return cell
    }
}
