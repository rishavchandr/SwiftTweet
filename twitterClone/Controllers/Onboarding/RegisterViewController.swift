//
//  RegisterViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 17/07/25.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let registerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your Account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let emailTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registerAccButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .tweeterBlueColor
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.isEnabled = false
        return button
    }()
    
    @objc private func didChangeEmailField(){
        viewModel.email = emailTextField.text
        viewModel.vaildateAuthenticationForm()
    }
    
    @objc private func didChangePasswordField(){
        viewModel.password = passwordTextField.text
        viewModel.vaildateAuthenticationForm()
    }
    
    private func bindView() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormVaild.sink { [weak self] validation in
            self?.registerAccButton.isEnabled = validation
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink{ [weak self] user in
            guard user != nil else {return}
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else {return}
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else {return}
            self?.presentAlet(with: error)
        }
        .store(in: &subscriptions)
    }
    
    private func presentAlet(with error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okayButton)
        present(alert , animated:  true)
        
    }
    
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    
    @objc private func createAUser() {
        viewModel.createUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(registerLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerAccButton)
        bindView()
        congfigureContraint()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        registerAccButton.addTarget(self, action: #selector(createAUser), for: .touchUpInside)
    }
    
    private func congfigureContraint(){
        
        let registerLabelConstraint = [
            registerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 20),
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let emailTextFieldConstraint = [
            emailTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor , constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let passwordTextFieldConstraint = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor , constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let registerButtonConstraint = [
            registerAccButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            registerAccButton.widthAnchor.constraint(equalToConstant: 150),
            registerAccButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerAccButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(registerLabelConstraint)
        NSLayoutConstraint.activate(emailTextFieldConstraint)
        NSLayoutConstraint.activate(passwordTextFieldConstraint)
        NSLayoutConstraint.activate(registerButtonConstraint)
        
    }

}
