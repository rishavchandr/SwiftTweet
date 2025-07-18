//
//  OnboardingViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 14/07/25.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "See whats's happening in world right now"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createAccButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let promotLabel: UILabel = {
        let label = UILabel()
        label.text = "Have an account already ?"
        label.tintColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("log in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [promotLabel , loginButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(createAccButton)
        view.addSubview(bottomStack)
        createAccButton.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configureOnbaoradingViewConstaint()
    }
    
    @objc func handleTap(_ sender: UIButton){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapLogin(_ sender: UIButton){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func configureOnbaoradingViewConstaint(){
        let welcomelabelConstraint = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let createAccButtonConstraint = [
            createAccButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor , constant: 30),
            createAccButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor , constant: -30),
            createAccButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let bottomStackConstraint = [
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(welcomelabelConstraint)
        NSLayoutConstraint.activate(createAccButtonConstraint)
        NSLayoutConstraint.activate(bottomStackConstraint)
    }

}
