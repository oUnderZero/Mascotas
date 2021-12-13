//
//  MenuViewController.swift
//  EsqueletonProject
//
//  Created by marco alonso on 07/01/21.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu Principal"
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesion(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToViewController(ofClass: HomeLoginViewController.self)
        
    }
    
    @IBAction func alertaButton(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Ejemplo de algo", message: "Ejemplo de mensaje", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            //codigo para hacer algo
            print("Hola")
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alerta, animated: true, completion: nil)
    }
    
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
