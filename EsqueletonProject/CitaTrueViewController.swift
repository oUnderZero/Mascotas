//
//  CitaTrueViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 16/12/21.
//

import UIKit

class CitaTrueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapaBtn(_ sender: Any) {
        performSegue(withIdentifier: "map", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map" {
            let objEdit = segue.destination as! MapaViewController
            objEdit.direccion = "Calle Sierra de Pichataro 554A, Santiaguito, 58110 Morelia, Mich."
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
