//
//  TweetComposeViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 24/07/25.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    
    
    private let viewModel = TweetComposeViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tweeterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        return button
    }()
    
    var  tweetProfileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.backgroundColor = .gray
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let tweetTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's Happening?"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        view.addSubview(tweetButton)
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        view.addSubview(tweetProfileImage)
        view.addSubview(tweetTextView)
        tweetTextView.delegate = self
        configureConstraint()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUser()
    }
    
    private func bindView() {
        viewModel.$isVaildTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = state
        }
        .store(in: &subscriptions)
        
        viewModel.$shouldDismissCompose.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    @objc func didTapToTweet(){
        viewModel.dispatchTweet()
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    private func configureConstraint() {
        let tweetbuttonConstraint = [
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor , constant: -10),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.widthAnchor.constraint(equalToConstant: 120),
            tweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        
        let tweetProfileConstraint = [
            tweetProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tweetProfileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            tweetProfileImage.widthAnchor.constraint(equalToConstant: 40),
            tweetProfileImage.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let tweetTextViewConstraint = [
            tweetTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tweetTextView.leadingAnchor.constraint(equalTo: tweetProfileImage.trailingAnchor, constant: 5),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetTextView.heightAnchor.constraint(equalToConstant: 250)
            
        ]
        
        NSLayoutConstraint.activate(tweetbuttonConstraint)
        NSLayoutConstraint.activate(tweetProfileConstraint)
        NSLayoutConstraint.activate(tweetTextViewConstraint)
    }
    
    
}

extension TweetComposeViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's Happening?"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateTweet()
    }
}
