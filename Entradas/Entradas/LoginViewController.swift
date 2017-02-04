//
//  LoginViewController.swift
//  Entradas
//
//  Created by Gustavo Aceredo on 30/01/17.
//  Copyright © 2017 Gustavo Aceredo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate{

    @IBOutlet weak var correo: UITextField!
    
    @IBOutlet weak var buttonGoogle: UIButton!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var buttonFacebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                
                let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let homeView: UIViewController = mainStory.instantiateViewController(withIdentifier: "HomeView")
                self.present(homeView, animated: true, completion: nil)
                
            } else {
                
                print("El usuario no Inicio Sesion")
                GIDSignIn.sharedInstance().uiDelegate = self
                self.setupGoogleButtons()
                
                self.setupFacebookButtons()
                
            }
        }

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func IniciarSesion(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: correo.text!, password: password.text!, completion: {
            user, error in
            
            if error != nil {
                
                print("Contraseña o Usuario incorrecto")
                
            }else {
                
                print("Login Correcto")
                
                let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let homeView: UIViewController = mainStory.instantiateViewController(withIdentifier: "HomeView")
                self.present(homeView, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    fileprivate func setupGoogleButtons() {
        
        let customButton = buttonGoogle
        customButton?.addTarget(self, action: #selector(handleCustomGoogleSign), for: .touchUpInside)
        customButton?.setTitleColor(.white, for: .normal)
        customButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(customButton!)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func handleCustomGoogleSign() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    
    
    
    
    // Utilizado para Facebook
    fileprivate func setupFacebookButtons() {
        
        
        let customFBButton = buttonFacebook
        customFBButton?.setTitleColor(.white, for: .normal)
        view.addSubview(customFBButton!)
        
        customFBButton?.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    // Delegate
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    // Delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        self.buttonFacebook.isHidden = true
        if (error != nil) {
            self.buttonFacebook.isHidden = false
        } else if (result.isCancelled){
            self.buttonFacebook.isHidden = false
        }else{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                
                print("Se registro en Firebase")
            }
            
        }
        
        
        print("Ingresa")
    }
    
    
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
}
