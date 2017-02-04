//
//  FirstViewController.swift
//  Entradas
//
//  Created by Gustavo Aceredo on 30/01/17.
//  Copyright © 2017 Gustavo Aceredo. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()



    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func CerrarSesion(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let homeView: UIViewController = mainStory.instantiateViewController(withIdentifier: "LoginView")
        self.present(homeView, animated: true, completion: nil)
        
    }

}

