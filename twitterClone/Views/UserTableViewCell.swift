//
//  UserTableViewCell.swift
//  twitterClone
//
//  Created by Rishav chandra on 31/07/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier: String = "UserTableViewCell"
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.backgroundColor = .gray
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let displayName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImage)
        contentView.addSubview(displayName)
        contentView.addSubview(userName)
        configureConstraint()
    }
    
    
    func configure(with user: TweetUser){
        profileImage.setImage(from: user.avatarPath)
        displayName.text = user.displayName
        userName.text = "@\(user.username)"
    }
    
    private func configureConstraint() {
        
        let profileImageConstraint = [
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let displayNameConstraint = [
            displayName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            displayName.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 15)
        ]
        
        let userNameConstraint = [
            userName.leadingAnchor.constraint(equalTo: displayName.leadingAnchor),
            userName.topAnchor.constraint(equalTo: displayName.bottomAnchor , constant: 5)
        ]
        
        NSLayoutConstraint.activate(profileImageConstraint)
        NSLayoutConstraint.activate(displayNameConstraint)
        NSLayoutConstraint.activate(userNameConstraint)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
