//
//  SplashScreenViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit


class SplashScreenViewController: UIViewController {
    
    var isRegistering: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.segueToLogin:
            guard let navController = segue.destination as? UINavigationController, let regLoginVC = navController.viewControllers.first as? RegisterLoginViewController else { return }
            regLoginVC.registering = isRegistering
        default:
            break
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        isRegistering = true
        self.performSegue(withIdentifier: Segues.segueToLogin, sender: self)
    }
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        isRegistering = false
        self.performSegue(withIdentifier: Segues.segueToLogin, sender: self)
    }
}
