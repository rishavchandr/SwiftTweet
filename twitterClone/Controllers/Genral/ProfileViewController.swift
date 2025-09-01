//
//  ProfileViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 05/07/25.
//

import UIKit
import Combine
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewViewModel
    
    init(viewModel: ProfileViewViewModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder: NSCoder) {
           fatalError()
       }
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private var isStatusBarHidden  = true
    
    private lazy var headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 400))
    
    private let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view;
    }()
    
    private let profileTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBarView)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        configConstraint()
        bindView()
        viewModel.fetchUserTweets()
    }
    
    private func bindView(){
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            self?.headerView.displayName.text = user.displayName
            self?.headerView.userName.text = "@\(user.username)"
            self?.headerView.followerCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBio.text = user.bio
            self?.headerView.profileImage.setImage(from: user.avatarPath)
            self?.headerView.joinDateLabel.text = "Joinet \(self?.viewModel.dateFormatter(with: user.createdON) ?? "")"
        }
        .store(in: &subscriptions)
        
        viewModel.$currentState.sink { [weak self] state in
            switch state {
            case .personal:
                self?.headerView.configureButtonAsPersonal()
            case .userIsFollwed:
                self?.headerView.configureButtonAsFollowed()
            case .userIsUnfollwed:
                self?.headerView.configureButtonAsUnFollowed()
            }
        }
        .store(in: &subscriptions)
        
        headerView.followButtonActionPublisher.sink {[weak self] state in
            switch state {
            case .userIsFollwed:
                self?.viewModel.isUnfollow()
            case .userIsUnfollwed:
                self?.viewModel.isFollow()
            case .personal:
                return
            }
        }
        .store(in: &subscriptions)
        
    }
    
    
    func configConstraint() {
        
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let statusBarContraint = [
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 50 : 30)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarContraint)
    }
}

extension ProfileViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as?
                TweetTableViewCell else { return UITableViewCell() }
        let currentUserId = viewModel.user.id
        let tweet = viewModel.tweets[indexPath.row]
        cell.configureTweet(displayName: tweet.author.displayName,
                            username: tweet.author.username,
                            tweetContent: tweet.tweetContent,
                            avatarPath: tweet.author.avatarPath,
                            likesCount: tweet.likesCount,
                            retweetCount: tweet.retweetCount,
                            isLike: tweet.likers.contains(currentUserId),
                            isRetweet: tweet.retweeters.contains(currentUserId))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yposition = scrollView.contentOffset.y
        
        if yposition > 150 {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0,options: .curveLinear) { [weak self] in
                self?.statusBarView.layer.opacity = 1
            }
        }else if yposition < 0 {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBarView.layer.opacity = 0
            }
        }
    }
}
