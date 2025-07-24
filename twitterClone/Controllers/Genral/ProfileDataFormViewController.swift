//
//  ProfileDataFormViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 18/07/25.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFormViewController: UIViewController {
    
    let viewModel = ProfileDataFormViewModel()
    private var subscriptions: Set<AnyCancellable> = []
     
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete your profile"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let  avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let displayNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .secondarySystemFill
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.attributedPlaceholder = NSAttributedString(string: "Name" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .secondarySystemFill
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.attributedPlaceholder = NSAttributedString(string: "username" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .tweeterBlueColor
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.isEnabled = false
        return button
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Tell the world about yourself"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        isModalInPresentation = true
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(avatarImageView)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        bioTextView.delegate = self
        displayNameTextField.delegate = self
        usernameTextField.delegate = self
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToAvatar)))
        submitButton.addTarget(self, action: #selector(clickOnSubmit), for: .touchUpInside)
        configureConstraint()
        bindView()
    }
    
    
    
    private func bindView() {
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingDidEnd)
        usernameTextField.addTarget(self, action: #selector(didUpdateUserName), for: .editingChanged)
        viewModel.$isFormVaild.sink { [weak self] buttonSate in
            self?.submitButton.isEnabled = buttonSate
        }
        .store(in: &subscriptions)
        
        
        viewModel.$isOnboardingDone.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    @objc private func didUpdateDisplayName(){
        viewModel.displayName = displayNameTextField.text
        viewModel.validateProfileDataForm()
    }
    
    @objc private func didUpdateUserName() {
        viewModel.username = usernameTextField.text
        viewModel.validateProfileDataForm()
    }
    
    @objc private func clickOnSubmit(_sender: UIButton) {
        viewModel.uploadAvatar()
    }
    
    @objc private func didTapToDismiss() {
        scrollView.endEditing(true)
    }
    
    @objc private func didTapToAvatar() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func configureConstraint() {
        let scrollViewConstrait  = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let titleLabelConstrait = [
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20)
        ]
        
        let avatarImageViewConstrait = [
            avatarImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ]
        
        let displayNameTextFieldConstraint = [
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let usernameTextFieldConstraint = [
            usernameTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            usernameTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let bioTextViewConstraint = [
            bioTextView.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let submitButtonConstraint = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor , constant: -20)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstrait)
        NSLayoutConstraint.activate(titleLabelConstrait)
        NSLayoutConstraint.activate(avatarImageViewConstrait)
        NSLayoutConstraint.activate(usernameTextFieldConstraint)
        NSLayoutConstraint.activate(displayNameTextFieldConstraint)
        NSLayoutConstraint.activate(bioTextViewConstraint)
        NSLayoutConstraint.activate(submitButtonConstraint)
    }

}

extension ProfileDataFormViewController: UITextViewDelegate , UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
     scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text.isEmpty {
            textView.text = "Tell the world about yourself"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text
        viewModel.validateProfileDataForm()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object , error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                        self?.viewModel.imageData = image
                        self?.viewModel.validateProfileDataForm()
                    }
                }
            }
        }
    }
}
