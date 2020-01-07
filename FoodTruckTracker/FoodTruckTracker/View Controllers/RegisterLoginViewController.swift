//
//  ViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/6/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleMessageLabel: UILabel!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupLoginLabel: UILabel!
    @IBOutlet weak var signupLoginButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    let apiController = APIController()
    var registering: Bool = true
    var vendor: VendorLogin?
    var consumer: ConsumerLogin?
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        updateViews()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private
    private func updateViews() {
        switch registering {
        case true:
            titleLabel.text = "Sign Up"
            titleMessageLabel.text = "Enter your username, email and password to create an account. Your privacy is important to us and will not be shared."
            signupLoginLabel.text = "Already a user?"
            signupLoginButton.setTitle("    LOG IN", for: .normal)
            submitButton.setTitle("SIGN UP", for: .normal)
            emailTextField.isHidden = false
        case false:
            titleLabel.text = "Log In"
            titleMessageLabel.text = "Enter your username and password. Your privacy is important to us and will not be shared."
            signupLoginLabel.text = "No Account?"
            signupLoginButton.setTitle("    SIGN UP", for: .normal)
            emailTextField.isHidden = true
            submitButton.setTitle("LOG IN", for: .normal)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Actions
    @IBAction func signupLoginButtonTapped(_ sender: UIButton) {
        registering.toggle()
        updateViews()
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        switch registering {
        case true:
            guard let username = usernameTextField.text, !username.isEmpty,
                let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let role = Role(rawValue: roleSegmentedControl.selectedSegmentIndex + 1) else { return }
            print("Username: \(username), Email: \(email), Password: \(password), Role: \(role)")
            apiController.register(with: username, password: password, email: email, role: role) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                
                self.showAlert(title: "Sign Up Successful", message: "Please Log In")
                self.registering.toggle()
                self.updateViews()
            }
        case false:
            guard let username = usernameTextField.text, !username.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let role = Role(rawValue: roleSegmentedControl.selectedSegmentIndex + 1) else { return }
            apiController.login(with: username, password: password, role: role) { consumer, vendor, bearer, error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                self.showAlert(title: "Log In Successful", message: "")
            }
        }
    }
}

extension RegisterLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
