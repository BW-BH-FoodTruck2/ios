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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupLoginLabel: UILabel!
    @IBOutlet weak var signupLoginButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    let apiController = APIController()
    var registering: Bool = true
    var vendor: VendorLogin?
    var consumer: ConsumerLogin?
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.style = .large
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
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
        case false:
            titleLabel.text = "Log In"
            titleMessageLabel.text = "Enter your username and password. Your privacy is important to us and will not be shared."
            signupLoginLabel.text = "No Account?"
            signupLoginButton.setTitle("    SIGN UP", for: .normal)
            submitButton.setTitle("LOG IN", for: .normal)
        }
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func showAlert(title: String, message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.myAccountSegue:
            guard let startScreen = segue.destination as? UITabBarController else { return }
            
            if let navController = startScreen.viewControllers?.last as? UINavigationController, let myAccountVC = navController.viewControllers.first as? MyAccountViewController {
                myAccountVC.consumer = consumer
            }
            
            if let navController = startScreen.viewControllers?.first as? UINavigationController, let startScreenVC = navController.viewControllers.first as? StartScreenViewController {
                startScreenVC.vendor = vendor
                startScreenVC.consumer = consumer
            }
        default:
            break
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Actions
    @IBAction func signupLoginButtonTapped(_ sender: UIButton) {
        registering.toggle()
        updateViews()
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        switch registering {
        case true:
            guard let username = usernameTextField.text, !username.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let role = Role(rawValue: roleSegmentedControl.selectedSegmentIndex + 1) else { return }
            apiController.register(with: username, password: password, role: role) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
                
                self.showAlert(title: "Sign Up Successful", message: "Please Log In") {
                    self.performSegue(withIdentifier: "MyAccountSegue", sender: self)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
                self.registering.toggle()
                self.updateViews()
            }
        case false:
            guard let username = usernameTextField.text, !username.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let role = Role(rawValue: roleSegmentedControl.selectedSegmentIndex + 1) else { return }
            apiController.login(with: username, password: password, role: role) { [weak self] consumer, vendor, error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
                
                if let consumer = consumer {
                    self.consumer = consumer
                }
                
                if let vendor = vendor {
                    self.vendor = vendor
                }
                
                self.showAlert(title: "Log In Successful", message: "") {
                    self.performSegue(withIdentifier: "MyAccountSegue", sender: self)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
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
