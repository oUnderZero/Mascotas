//
//  EditarPerfilViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 13/01/21.
//

import UIKit
import Firebase
import FirebaseStorage
class EditarPerfilViewController: UIViewController {

    @IBOutlet weak var imagePerfil: UIImageView!
    let db = Firestore.firestore()
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var dirr: UITextView!
    var img: UIImage?
    var id_img: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePerfil.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cambiarFotoPerfil))
        imagePerfil.addGestureRecognizer(gesture)
        let defaults = UserDefaults.standard
        if let imagenid = defaults.value(forKey: "idimagen") as? String {
            print("asdasd")
            id_img = imagenid
            let query2 = Firestore.firestore().collection("Imagenes").whereField("id", isEqualTo: imagenid )
                     query2.getDocuments { (snapshot, error) in
                         if let err = error {
                             print("Error al descargar imagen: \(err.localizedDescription)")
                         }
                         guard let snapshot = snapshot,
                               let data = snapshot.documents.first?.data(),
                               let urlString = data["url"] as? String,
                               
                               let url = URL(string: urlString)
                         else { return }
                         
                                DispatchQueue.global().async { [weak self] in
                                    if let data = try? Data(contentsOf: url) {
                                        if let image = UIImage(data: data) {
                                            DispatchQueue.main.async {
                                                self?.imagePerfil.image = image
                                            }
                                        }
                                    }
                                }
                     }
        }
       if let imagen = defaults.value(forKey: "imagen") as? UIImage
        {print("smn \(imagen)")
            imagePerfil.image = imagen 
        }
        if let email = defaults.value(forKey: "email") as? String {
            nombreTextField.text = Auth.auth().currentUser?.email
        }
       
    }
    
    @objc func cambiarFotoPerfil(){
        print("Seleccionar foto de perfil")
        presentFotoActionSheet()
    }
   
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func tomarFoto(_ sender: UIBarButtonItem) {
        presentFotoActionSheet()
    }
    @IBAction func ubicacionBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "mapa", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapa" {
            let objEdit = segue.destination as! MapaViewController
            objEdit.direccion = self.dirr.text
            
        }
    }
    @IBAction func GuardarBtn(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        var uidd: String?
        if let uid = defaults.value(forKey: "uid") as? String {
            uidd = uid
        }
        
        Auth.auth().currentUser?.updateEmail(to: nombreTextField.text!) { error in
            if let err = error {
                print(err)
              
            } else {
                
                
                self.db.collection("Usuarios").whereField("uid", isEqualTo: uidd!)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for documento in querySnapshot!.documents {
                                
                                let query2 = self.db.collection("Usuarios").document(documento.documentID)
                                query2.updateData([
                                    "email": self.nombreTextField.text!
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("email actaulziada correctamente")
                                    }
                                }
                            }
                        }


            }

        }
       
        
        
                
               
        }
         
       
       
       
        guard let image = imagePerfil.image, let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let NombreImage = UUID().uuidString
        let referenceImage = Storage.storage()
            .reference()
            .child("imagenes")
            .child("usuarios")
            .child(NombreImage)
        referenceImage.putData(imageData, metadata: nil) { (metaData, error) in
            if let err = error {
                print("Error al subir imagen \(err.localizedDescription)")
            }
            
            referenceImage.downloadURL { (url, error) in
                if let err = error {
                    print("Error al subir imagen \(err.localizedDescription)")
                }
                
                guard let url = url else {
                    print("Error al crear la URL de la imagen")
                    return
                }
                let urlString = url.absoluteString
                let query = self.db.collection("Imagenes").document(self.id_img!)
               
                // Set the "capital" field of the city 'DC'
                query.updateData([
                    "url": urlString
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        self.performSegue(withIdentifier: "back", sender: self)
                        print("imagen actaulziada correctamente")
                    }
                }
                
                
              
            }
        }
        
    }
    
}

//MARK: - Seleccionar foto
extension EditarPerfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //ActionSheet para seleccionar foto
    func presentFotoActionSheet() {
        let actionSheet = UIAlertController(title: "Foto de Perfil", message: "¿Como quieres elegir una foto?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancelar",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Tomar una foto",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamara()
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Elegir una existente",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentLibreria()
                                            }))
        present(actionSheet, animated: true)
    }
    
    func presentCamara(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentLibreria() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let imagenSeleccionada = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imagePerfil.image = imagenSeleccionada
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelar")
        picker.dismiss(animated: true, completion: nil)
    }
}

