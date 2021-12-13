//
//  AddMascotaViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 11/12/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddMascotaViewController: UIViewController {
    @IBOutlet weak var ImagenMascota: UIImageView!
    @IBOutlet weak var NombreText: UITextField!
    @IBOutlet weak var RazaText: UITextField!
    @IBOutlet weak var EdadText: UITextField!
    let db = Firestore.firestore()
    var img: UIImage?
    var id_img: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagenMascota.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cambiarFotoPerfil))
        ImagenMascota.addGestureRecognizer(gesture)
        
      
            print("asdasd")
           
        
       
        
    }
    
    @IBAction func Guardarbtn(_ sender: UIBarButtonItem) {
        var aidi: String
        aidi = ""
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
                
                var ref: DocumentReference? = nil
                ref = self.db.collection("Imagenes").addDocument(data: [
                    "id": " " ,
                    "url": urlString
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                aidi = ref!.documentID
                
                let query = self.db.collection("Imagenes").document(aidi)
               
                // Set the "capital" field of the city 'DC'
                query.updateData([
                    "id": ref!.documentID
                ]) { err in

                }
                 
                var ref2: DocumentReference? = nil
                ref2 = self.db.collection("Mascotas").addDocument(data: [
                    "Edad": self.EdadText.text!,
                    "Nombre": self.NombreText.text!,
                    "Raza": self.RazaText.text!,
                    "id_imagen": aidi,
                    "uid": Auth.auth().currentUser?.uid ?? ""
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref2!.documentID)")
                    }
                }
                self.performSegue(withIdentifier: "backk", sender: self)
                
                
                
               
             }
         }
        
     }
        
 
    
    @IBAction func Imagen(_ sender: UIBarButtonItem) {
        presentFotoActionSheet()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func cambiarFotoPerfil(){
        print("Seleccionar foto de perfil")
        presentFotoActionSheet()
    }

}



extension AddMascotaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
