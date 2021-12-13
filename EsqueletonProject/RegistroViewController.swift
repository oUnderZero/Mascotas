//
//  RegistroViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 07/01/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
class RegistroViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseñaTextField: UITextField!
    @IBOutlet weak var registrarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registroButton(_ sender: Any) {
        let db = Firestore.firestore()
        if let email = correoTextField.text, let password = contraseñaTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let result = result,  error == nil {
                    
                    // Add a new document with a generated id.
                    var ref: DocumentReference? = nil
                    ref = db.collection("Usuarios").addDocument(data: [
                        "email": email,
                        "uid": result.user.uid,
                        "id_imagen": "J8z0CjeEySLcOQu4rda4"
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                    self.performSegue(withIdentifier: "RegisterMain", sender: self)

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
