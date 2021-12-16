//
//  editMascotaViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 15/12/21.
//

import UIKit
import Firebase
import FirebaseStorage
class editMascotaViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var NombreMascota: UITextField!
    @IBOutlet weak var RazaMascota: UITextField!
    @IBOutlet weak var EdadMascota: UITextField!
    @IBOutlet weak var PesoMascota: UITextField!
    @IBOutlet weak var ImagenMascota: UIImageView!
    var id_img: String?
    let db = Firestore.firestore()
    var img: UIImage?
    var kuid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mascotas = defaults.object(forKey: "mascota") as? [String:String] ?? [:]
        kuid = mascotas["uid_mascota"]!
        NombreMascota.text = mascotas["Nombre"]
        RazaMascota.text = mascotas["Raza"]
        EdadMascota.text = mascotas["Edad"]
        PesoMascota.text = mascotas["Peso"]
        print(mascotas["Nombre"] ?? " ")
        defaults.removeObject(forKey: "mascota")
        
        ImagenMascota.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cambiarFotoPerfil))
        ImagenMascota.addGestureRecognizer(gesture)
   
      
           
                    id_img = mascotas["Imagen"]
        let query2 = Firestore.firestore().collection("Imagenes").whereField("id", isEqualTo: id_img ?? " " )
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
                                                self?.ImagenMascota.image = image
                                            }
                                        }
                                    }
                                }
                     }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func cambiarFotoPerfil(){
        print("Seleccionar foto de perfil")
        presentFotoActionSheet()
    }
    @IBAction func GuardarBtnn(_ sender: UIBarButtonItem) {
        
        
        self.db.collection("Mascotas").whereField("uid_mascota", isEqualTo: self.kuid)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for documento in querySnapshot!.documents {
                        let query2 = self.db.collection("Mascotas").document(documento.documentID)
                        query2.updateData([
                            "Nombre": NombreMascota.text!,
                            "Edad": EdadMascota.text!,
                            "Peso": PesoMascota.text!,
                            "Raza": RazaMascota.text!,
                            
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Mascotas actualizadas correctamente")
                            }
                        }
                    }
                }


    }
        
        
        
         guard let image = ImagenMascota.image, let imageData = image.jpegData(compressionQuality: 1.0) else {
             return
         }
         
         let NombreImage = UUID().uuidString
         let referenceImage = Storage.storage()
             .reference()
             .child("imagenes")
             .child("mascotas")
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
                         self.performSegue(withIdentifier: "volverregistro", sender: self)
                         print("imagen actaulziada correctamente")
                     }
                 }
                 
                 
               
             }
         }
        
        
    }
    
}

//MARK: - Seleccionar foto
extension editMascotaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        self.ImagenMascota.image = imagenSeleccionada
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelar")
        picker.dismiss(animated: true, completion: nil)
    }
}

