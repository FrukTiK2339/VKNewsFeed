//
//  AuthViewController.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 07.07.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .red
    }

    @IBAction func signInTouch(_ sender: Any) {
        authService.wakeUpSession()
    }
    
}

