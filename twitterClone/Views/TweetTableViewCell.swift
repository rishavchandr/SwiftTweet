//
//  TweetTableViewCell.swift
//  twitterClone
//
//  Created by Rishav chandra on 26/06/25.
//

import UIKit


protocol tweetTableViewCellDelegate: AnyObject {
    func didTapToReplyButton()
    func didTapToRetweetButton()
    func didTapToLikeButton()
    func didTapToShareButton()
}

class TweetTableViewCell: UITableViewCell {
    
    static let identifier = "TweetTableViewCell"
    
    
    weak var delegate: tweetTableViewCellDelegate?
  
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetContentLabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        configureConstraint()
        configureButton()
        
    }
    
    func configureTweet(displayName: String , username: String , tweetContent: String , avatarPath: String){
        displayNameLabel.text = displayName
        userNameLabel.text = "@\(username)"
        tweetContentLabel.text = tweetContent
        avatarImageView.setImage(from: avatarPath)
    }
    
    @objc private func didTapReply(){
        delegate?.didTapToReplyButton()
    }
    
    @objc private func didTapRetweet(){
        delegate?.didTapToRetweetButton()
        retweetButton.tintColor = .green
    }
    
    @objc private func didTapLike(){
        delegate?.didTapToLikeButton()
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .systemPink
    }
    
    @objc private func didTapShare(){
        delegate?.didTapToShareButton()
    }
    
    
    private func  configureButton(){
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweet), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    private func configureConstraint() {
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
            replyButton.leadingAnchor.constraint(equalTo: tweetContentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: tweetContentLabel.bottomAnchor , constant: 15),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -15)
        ]
         
        let retweetButtonConstraint = [
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor , constant: 50),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)

        ]
        let likeButtonConstraint = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor , constant: 50),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)

        ]
        
        let shareButtonConstraint = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor , constant: 50),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)

        ]
        
        NSLayoutConstraint.activate(avatarImageConstraint)
        NSLayoutConstraint.activate(displayNameConstaint)
        NSLayoutConstraint.activate(userNameConstraint)
        NSLayoutConstraint.activate(tweetContentConstraint)
        NSLayoutConstraint.activate(replyButtonConstraint)
        NSLayoutConstraint.activate(retweetButtonConstraint)
        NSLayoutConstraint.activate(likeButtonConstraint)
        NSLayoutConstraint.activate(shareButtonConstraint)

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
