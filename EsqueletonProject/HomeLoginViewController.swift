//
//  ViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 07/01/21.
//

import UIKit
import FirebaseAuth
class HomeLoginViewController: UIViewController {

    @IBOutlet weak var CorreoTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
  

    @IBAction func IniciarSesionButton(_ sender: Any) {
        if let email = CorreoTextField.text, let password = PasswordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result,  error == nil {
                    self.performSegue(withIdentifier: "LoginMain", sender: self)

                    //self.navigationController?.pushViewController(HomeeViewController(email: result.user.email!, providers: .basic), animated: true)
                }else {
                    
                    let alertcontroller = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                    alertcontroller.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertcontroller, animated: true, completion: nil)
                }
            }
        }
        
    }
   
    
}

