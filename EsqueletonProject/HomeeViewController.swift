//
//  HomeeViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 11/12/21.
//

import UIKit
import FirebaseAuth
enum ProviderType: String {
    case basic
}

class HomeeViewController: UIViewController {
    
      @IBOutlet weak var correotext: UILabel!
      @IBOutlet weak var providertext: UILabel!
      private let email: String
      private let provider: ProviderType
      init(email: String, providers: ProviderType) {
          self.email = email
          self.provider = providers
          super.init(nibName: "HomeeViewController", bundle: nil)
          
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        correotext.text = email
        providertext.text = provider.rawValue        // Do any additional setup after loading the view.
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
