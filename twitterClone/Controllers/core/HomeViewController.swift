//
//  HomeViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 26/06/25.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var composeTweetButton: UIButton = {
        let button = UIButton(type: .system , primaryAction: UIAction{[weak self] _ in
            self?.navigateToTweetCompose()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tweeterBlueColor
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        let plusSign = UIImage(systemName: "plus" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        button.setImage(plusSign, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(composeTweetButton)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigationBar()
        configureConstraints()
        bindView()
    }
    
    @objc func didSignOut(){
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retrieveUser()
    }
    
    private func completeOnboarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    private func bindView() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else {return}
            if !user.isUserOnboard {
                self?.completeOnboarding()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func configureNavigationBar() {
        let size = 36
        let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImage.contentMode = .scaleAspectFill
        logoImage.image = UIImage(named: "twitterlogo")
        
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImage)
        navigationItem.titleView = middleView
        
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didSignOut))
        
    }
    
    private func navigateToTweetCompose() {
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @objc func didTapProfile(){
        guard let user = viewModel.user else {return}
        let profileViewModel = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureConstraints() {
        
        let composeButtonConstraint = [
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(composeButtonConstraint)
    }

}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath)
                as? TweetTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        let tweetIndex = viewModel.tweets[indexPath.row]
        cell.configureTweet(displayName: tweetIndex.author.displayName,
                            username: tweetIndex.author.username,
                            tweetContent: tweetIndex.tweetContent,
                            avatarPath: tweetIndex.author.avatarPath)
        
        return cell
    }
    
}

extension HomeViewController: tweetTableViewCellDelegate {
    
    func didTapToReplyButton() {
        print("Reply")
    }
    
    func didTapToRetweetButton() {
        print("Retweet")
    }
    
    func didTapToLikeButton() {
        print("Like")
    }
    
    func didTapToShareButton() {
        print("Share")
    }
    
}
