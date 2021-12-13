//
//  DetalleArchivoViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 13/01/21.
//

import UIKit

class DetalleArchivoViewController: UIViewController {
    
    var recibirArchivo: String?

    @IBOutlet weak var archivoSeleccionado: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        archivoSeleccionado.text = recibirArchivo

        // Do any additional setup after loading the view.
    }
    



}
