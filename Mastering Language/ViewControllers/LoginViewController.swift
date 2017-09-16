//
//  LoginViewController.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import GoogleSignIn
import ChameleonFramework

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    var loginComplete: (() -> ())?
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    convenience init(loginComplete:  (() -> ())?) {
        self.init()
        
        self.loginComplete = loginComplete
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: [UIColor.flatPowderBlue, UIColor.flatSkyBlue, UIColor.flatBlue])
        setupGoogleSignIn()
    }
    
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
    }
}
