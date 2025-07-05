//
//  ProfileHeaderView.swift
//  twitterClone
//
//  Created by Rishav chandra on 05/07/25.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private let displayName: UILabel = {
        let label = UILabel()
        label.text = "Rishav"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "rishav_02"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userBio: UILabel = {
        let label = UILabel()
        label.text =  "We must build dikes of courage to hold back the flood of fear"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.backgroundColor = .gray
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    private let profileHeaderImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray2
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImage)
        addSubview(profileImage)
        addSubview(displayName)
        addSubview(userName)
        addSubview(userBio)
        profileConfigureConstraint()
    }
    
    private func profileConfigureConstraint() {
        let profileHeaderConstraint = [
            profileHeaderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImage.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImage.heightAnchor.constraint(equalToConstant: 180)
        ]
        
        let profileImageConstraint = [
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.centerYAnchor.constraint(equalTo: profileHeaderImage.bottomAnchor , constant: 10),
            profileImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let displayNameConstraint = [
            displayName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            displayName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20)
        ]
        
        let userNameConstraint = [
            userName.leadingAnchor.constraint(equalTo: displayName.leadingAnchor),
            userName.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 5)
        ]
        
        let userBioConstraint = [
            userBio.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
            userBio.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
            userBio.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5)
        ]
        
        NSLayoutConstraint.activate(profileHeaderConstraint)
        NSLayoutConstraint.activate(profileImageConstraint)
        NSLayoutConstraint.activate(displayNameConstraint)
        NSLayoutConstraint.activate(userNameConstraint)
        NSLayoutConstraint.activate(userBioConstraint)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

}
