//
//  LogInViewController.swift
//  AC3.2-Final
//
//  Created by Marty Avedon on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

// based on code from https://github.com/C4Q/AC3.2-U6-Graphy/blob/master/Graffy/UserViewController.swift

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    let databaseReference = FIRDatabase.database().reference().child("Users")
    var databaseObserver:FIRDatabaseHandle?
    var signInUser: FIRUser?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setupViewHierarchy()
        
        let loggedInAlready = tabBarController
        
        if FIRAuth.auth()?.currentUser != nil {
            self.navigationController?.pushViewController(loggedInAlready!, animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureConstraints()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        self.view.addSubview(logo)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        
        loginButton.addTarget(self, action: #selector(didTapLogin(sender:)) , for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registeredPressed(sender:)), for: .touchUpInside)
    }
    
    func configureConstraints() {
        logo.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(10)
        }
        
        emailTextField.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.8)
            view.top.equalTo(logo.snp.bottom).offset(40)
        }
        
        passwordTextField.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.8)
            view.top.equalTo(emailTextField.snp.bottom).offset(30)
        }
        
        registerButton.snp.makeConstraints { (view) in
            view.leading.equalTo(passwordTextField.snp.centerX)
            view.top.equalTo(passwordTextField.snp.bottom).offset(25)
            view.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { (view) in
            view.trailing.equalTo(registerButton.snp.leading)
            view.top.equalTo(passwordTextField.snp.bottom).offset(25)
            view.width.equalTo(registerButton)
            view.height.equalTo(registerButton)
        }
    }
    
    // MARK: - Actions
    
    func didTapLogin(sender: UIButton) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                if user != nil {
                    let newViewController = LogInViewController()
                    if let tabVC =  self.navigationController {
                        tabVC.show(newViewController, sender: nil)
                    }
                } else {
                        showAlert("Oops! we couldn't log you in!", presentOn: self)
                }
            })
        }
    }
    
    func registeredPressed(sender: UIButton) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print (error!)
                    
                    return
                }
                
                guard let uid = user?.uid else { return }
                
                let imageName = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
                
            })
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let userReference = self.databaseReference.child(uid)
        let newViewController = tabBarController
        
        userReference.updateChildValues(values)
        
        if let tabVC =  self.navigationController {
            tabVC.show(newViewController!, sender: nil)
        }
    }
    
    // MARK: - Lazy Properties
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        
        view.image = #imageLiteral(resourceName: "meatly_logo")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let view = UITextField()
        
        view.placeholder = "dummyEmail@yahoo.com"
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.textAlignment = .left
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let view = UITextField()
        
        view.placeholder = "Jello Biafra"
        view.isSecureTextEntry = true
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.textAlignment = .left
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
        
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        
        button.setTitle("REGISTER", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
        
        return button
    }()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
