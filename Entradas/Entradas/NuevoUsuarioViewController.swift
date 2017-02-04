//
//  NuevoUsuarioViewController.swift
//  Entradas
//
//  Created by academia moviles on 3/02/17.
//  Copyright © 2017 Gustavo Aceredo. All rights reserved.
//

import UIKit
import FirebaseAuth

class NuevoUsuarioViewController: UIViewController {

    
    @IBOutlet weak var correo: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func crearUsuario(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: correo.text!, password: password.text!, completion: { (user, error) in
            if(error != nil){
                print("Nose puee crear el usuario")
            }else{
                print("usuario creado")
            }
        })
    }


}
