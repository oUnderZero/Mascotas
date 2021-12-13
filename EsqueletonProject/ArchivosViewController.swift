//
//  ArchivosViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 13/01/21.
//

import UIKit

class ArchivosViewController: UIViewController {
    
    let peliculas = ["Ted","Spider Man","Avengers","Harry Potter"]
    var peliculaEnviar: String?

    @IBOutlet weak var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ArchivosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = peliculas[indexPath.row]
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabla.deselectRow(at: indexPath, animated: true)
        peliculaEnviar = peliculas[indexPath.row]
        performSegue(withIdentifier: "enviarArchivo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarArchivo" {
            let objArchivo = segue.destination as! DetalleArchivoViewController
            objArchivo.recibirArchivo = peliculaEnviar
        }
    }
    
    
}
