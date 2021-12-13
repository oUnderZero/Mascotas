//
//  MainViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 11/12/21.
//

import UIKit
import Firebase
import FirebaseFirestore
class MainViewController: UIViewController{
    var img_mascota: UIImage?
    
    var id: String?
    var id_img: String?
    var img: UIImage?
    var mascotas = [Mascota]()
    let db = Firestore.firestore()
    @IBOutlet weak var MascotasTable: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        MascotasTable.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MascotaTableViewCell", bundle: nil)
        MascotasTable.register(nib, forCellReuseIdentifier: "cell")
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        MascotasTable.reloadData()
        loadmascotas()
        if let email = Auth.auth().currentUser?.email {
            
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
            let query = Firestore.firestore().collection("Usuarios").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? " ")
            query.getDocuments { (snapshot, error) in
                if let err = error {
                    print("Error al descargar imagen: \(err.localizedDescription)")
                }
                
                guard let snapshot = snapshot,
                    
                      let data = snapshot.documents.first?.data(),
                      let idu = data["uid"] as? String,
                      let id_imga = data["id_imagen"] as? String
                else { return }
                
                self.id_img = id_imga
                
                defaults.set(idu, forKey: "uid")
                defaults.set(self.id_img, forKey: "idimagen")
            }
           
        }
    }
    
    @IBAction func EditPerfil(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditPerfil", sender: self)
    }
    
   
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "imagen")
        defaults.synchronize()
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    func loadmascotas() {
        db.collection("Mascotas").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? " ").order(by: "Nombre").addSnapshotListener() { (querySnapshot, err) in
            print("email \(Auth.auth().currentUser?.email! ?? " ")")
            
            self.mascotas = []
            
            if let e = err {
                print("Error al obtener las mascotass: \(e.localizedDescription)")
            } else {
                if let documentsSnapShot = querySnapshot?.documents {
                    for document in documentsSnapShot {
                        print("\(document.data())")
                        let data = document.data()
                        guard let Nombre = data["Nombre"] as? String else { return }
                        guard let Edad = data["Edad"] as? String else { return }
                        guard let Raza = data["Raza"] as? String else { return }
                        guard let id_imagen = data["id_imagen"] as? String else {return}
                        let newMascota = Mascota(Raza: Raza, Nombre: Nombre, Edad: Edad, id_imagen: id_imagen)
                        
                        
                        self.mascotas.append(newMascota)
                        
                        DispatchQueue.main.async {
                            self.MascotasTable.reloadData()
                        }
                    }
                }
            }
        }
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mascotas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MascotasTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MascotaTableViewCell
        
        
        let query = Firestore.firestore().collection("Imagenes").whereField("id", isEqualTo: mascotas[indexPath.row].id_imagen)
                query.getDocuments { (snapshot, error) in
                    if let err = error {
                        print("Error al descargar imagen: \(err.localizedDescription)")
                    }
                    print("asdasdasd\(indexPath.row)")
                    guard let snapshot = snapshot,
                          let data = snapshot.documents.first?.data(),
                          let urlString = data["url"] as? String,
                          let url = URL(string: urlString)
                    else { return }
                        
                           DispatchQueue.global().async { [weak self] in
                               if let data = try? Data(contentsOf: url) {
                                   if let image = UIImage(data: data) {
                                       DispatchQueue.main.async {
                                        cell.MascotaImage.image = image
                                       }
                                   }
                               }
                           }
                    
                }
                
        cell.NombreText.text = self.mascotas[indexPath.row].Nombre
        
        cell.RazaText.text = self.mascotas[indexPath.row].Raza
        cell.EdadText.text = self.mascotas[indexPath.row].Edad
        return cell
    }
    


}
