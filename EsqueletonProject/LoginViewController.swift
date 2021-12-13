//
//  LoginViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 07/01/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
    }
    

    

}
