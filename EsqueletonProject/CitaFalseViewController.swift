//
//  CitaFalseViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 16/12/21.
//

import UIKit
import Firebase
import FirebaseStorage
class CitaFalseViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 2
        // Do any additional setup after loading the view.
    }
    

    @IBAction func GenerarBtn(_ sender: Any) {
     
        let defaults = UserDefaults.standard
        let mascotas = defaults.object(forKey: "mascota") as? [String:String] ?? [:]
        let alert = UIAlertController(title: "Registro de cita", message: "Accion.", preferredStyle: UIAlertController.Style.alert)
        print(mascotas)
        // agregamos las acciones a la alerta
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {_ in
            
            let query = self.db.collection("Mascotas").document(mascotas["uid_mascota"]!)
           
            // Set the "capital" field of the city 'DC'
            query.updateData([
                "Cita": true
            ]) { err in

            }
            self.performSegue(withIdentifier: "return", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
         
        let peso = mascotas["Peso"]!.components(separatedBy: " ")
        
        let pesoint = Double(peso[0] )
        alert.message = "Esta apunto de registrar una cita con el veterinario, con el cachorro de nombre \(mascotas["Nombre"]!), Con un precio de \(pesoint!*50)$ Pesos"
        
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
