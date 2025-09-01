//
//  TweetViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 01/09/25.
//

import UIKit
import FirebaseAuth

class TweetViewController: UIViewController {
    
    private var tweet: Tweet
    
    init(tweet: Tweet){
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tweetContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let retweetCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let sepratorView: UIView = {
        let seprator = UIView()
        seprator.translatesAutoresizingMaskIntoConstraints = false
        seprator.backgroundColor = .lightGray
        return seprator
    }()
    
    private let replyTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        configureNavigationBar()
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetContentLabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(commentCountLabel)
        contentView.addSubview(retweetCountLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(sepratorView)
        contentView.addSubview(replyTableView)
        replyTableView.delegate = self
        replyTableView.dataSource = self
        configureConstraint()
        configureTweet()
    }
    
    func configureTweet(){
        displayNameLabel.text = tweet.author.displayName
        userNameLabel.text = "@\(tweet.author.username)"
        tweetContentLabel.text = tweet.tweetContent
        avatarImageView.setImage(from: tweet.author.avatarPath)
        likeCountLabel.text = "\(tweet.likesCount)"
        retweetCountLabel.text = "\(tweet.retweetCount)"
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        if tweet.likers.contains(userId) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemPink
            likeCountLabel.textColor = .systemPink
        }else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .systemGray
            likeCountLabel.textColor = .secondaryLabel
        }
        
        if tweet.retweeters.contains(userId) {
            retweetButton.tintColor = .green
            retweetCountLabel.textColor = .green
        }else{
            retweetButton.tintColor = .systemGray
            retweetCountLabel.textColor = .secondaryLabel
        }
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "post"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapBack))
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true)
    }
    
    private func configureConstraint(){
        let scrollViewConstraint = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let contentViewContraint = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        let avatarImageConstraint = [
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let displayNameConstaint = [
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            displayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        
        let userNameConstraint = [
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 20),
            userNameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ]
        
        let tweetContentConstraint = [
            tweetContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 10),
            tweetContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ]
        
        let replyButtonConstraint = [
            replyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            replyButton.topAnchor.constraint(equalTo: tweetContentLabel.bottomAnchor , constant: 15)
        ]
        
        let commentCountLabelContraint = [
            commentCountLabel.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: 5),
            commentCountLabel.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
         
        let retweetButtonConstraint = [
            retweetButton.leadingAnchor.constraint(equalTo: commentCountLabel.trailingAnchor , constant: 70),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)

        ]
        
        let retweetCountLabelContraint = [
            retweetCountLabel.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: 5),
            retweetCountLabel.centerYAnchor.constraint(equalTo: retweetButton.centerYAnchor)
        ]
        
        let likeButtonConstraint = [
            likeButton.leadingAnchor.constraint(equalTo: retweetCountLabel.trailingAnchor , constant: 70),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)

        ]
        
        let likeCountLabelContraint = [
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor)
        ]
        
        let shareButtonConstraint = [
            shareButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor , constant: 70),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)

        ]
        
        let sepratorViewConstraint = [
            sepratorView.topAnchor.constraint(equalTo: replyButton.bottomAnchor , constant: 20),
            sepratorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sepratorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        let ReplytableViewConstrant = [
            replyTableView.topAnchor.constraint(equalTo: sepratorView.bottomAnchor , constant: 20),
            replyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            replyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            replyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            replyTableView.heightAnchor.constraint(equalToConstant: 700)
        ]
        
        
        
        NSLayoutConstraint.activate(scrollViewConstraint)
        NSLayoutConstraint.activate(contentViewContraint)
        NSLayoutConstraint.activate(avatarImageConstraint)
        NSLayoutConstraint.activate(displayNameConstaint)
        NSLayoutConstraint.activate(userNameConstraint)
        NSLayoutConstraint.activate(tweetContentConstraint)
        NSLayoutConstraint.activate(replyButtonConstraint)
        NSLayoutConstraint.activate(retweetButtonConstraint)
        NSLayoutConstraint.activate(likeButtonConstraint)
        NSLayoutConstraint.activate(shareButtonConstraint)
        NSLayoutConstraint.activate(commentCountLabelContraint)
        NSLayoutConstraint.activate(retweetCountLabelContraint)
        NSLayoutConstraint.activate(likeCountLabelContraint)
        NSLayoutConstraint.activate(sepratorViewConstraint)
        NSLayoutConstraint.activate(ReplytableViewConstrant)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TweetViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "weclome to dubai"
        return cell
    }
    
    
}
