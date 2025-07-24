//
//  ProfileHeaderView.swift
//  twitterClone
//
//  Created by Rishav chandra on 05/07/25.
//

import UIKit

class ProfileHeaderView: UIView {
    
    
    private enum sectionTab: String {
        case tweet =  "Tweet"
        case tweetAndReplies = "Tweet & Replies"
        case media =  "Media"
        case likes = "likes"
        
        var index: Int {
            switch self {
            case .tweet:
                return 0
            case .tweetAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseOut) { [weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = (i == self?.selectedTab) ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = (i == self?.selectedTab) ? true : false
                    self?.trailingAnchors[i].isActive = (i == self?.selectedTab) ? true : false
                    self?.layoutIfNeeded()
                }
            }
        }
    }
    
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    
    private var tabs: [UIButton] = ["Tweet" , "Tweet & Replies" , "Media" , "likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.setTitle(buttonTitle, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 29/255 , green: 162/255 , blue: 242/255, alpha: 1)
        return view
    }()
    
    private lazy var sectionStack: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: tabs)
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.alignment = .center
        return stackview
    }()
    
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "followers"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var followerCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "following"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var followingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var displayName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userName: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userBio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var  profileImage: UIImageView = {
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
        image.backgroundColor = .systemMint
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var joinDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calenderImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "calendar")
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
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
        addSubview(joinDateLabel)
        addSubview(calenderImage)
        addSubview(followerLabel)
        addSubview(followingLabel)
        addSubview(followerCountLabel)
        addSubview(followingCountLabel)
        addSubview(sectionStack)
        addSubview(indicator)
        profileConfigureConstraint()
        configStacKButton()
    }
    
    
    private func configStacKButton(){
        for (i,button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else {return}
            
            if i == selectedTab {
                button.tintColor = .label
            }else{
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTapButton(_ sender: UIButton){
        guard let senderTitle = sender.titleLabel?.text else {return}
        
        switch senderTitle{
        case sectionTab.tweet.rawValue:
            selectedTab = 0
        case sectionTab.tweetAndReplies.rawValue:
            selectedTab = 1
        case sectionTab.media.rawValue:
            selectedTab = 2
        case sectionTab.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    private func profileConfigureConstraint() {
        
        for i in 0..<tabs.count {
            let leading_Anchor = indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leading_Anchor)
            
            let trailing_Anchor = indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailing_Anchor)
        }
        
        let profileHeaderConstraint = [
            profileHeaderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImage.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImage.heightAnchor.constraint(equalToConstant: 150)
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
        
        let calenderImageConstraint = [
            calenderImage.leadingAnchor.constraint(equalTo: userBio.leadingAnchor),
            calenderImage.topAnchor.constraint(equalTo: userBio.bottomAnchor, constant: 5),
        ]
        
        let joinDateConstraint = [
            joinDateLabel.leadingAnchor.constraint(equalTo: calenderImage.trailingAnchor , constant: 5),
            joinDateLabel.centerYAnchor.constraint(equalTo: calenderImage.centerYAnchor)
        ]
        
        let followingCountConstraint = [
            followingCountLabel.leadingAnchor.constraint(equalTo: displayName.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: calenderImage.bottomAnchor, constant: 10)
        ]
        
        let followingLabelConstraint = [
            followingLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 4),
            followingLabel.bottomAnchor.constraint(equalTo: followerCountLabel.bottomAnchor)
        ]
        
        let followerCountConstraint = [
            followerCountLabel.leadingAnchor.constraint(equalTo: followingLabel.trailingAnchor, constant: 8),
            followerCountLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let followerLabelConstraint = [
            followerLabel.leadingAnchor.constraint(equalTo: followerCountLabel.trailingAnchor, constant: 4),
            followerLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let sectionStackConstraint = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor,constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorConstraint = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        
        
        NSLayoutConstraint.activate(profileHeaderConstraint)
        NSLayoutConstraint.activate(profileImageConstraint)
        NSLayoutConstraint.activate(displayNameConstraint)
        NSLayoutConstraint.activate(userNameConstraint)
        NSLayoutConstraint.activate(userBioConstraint)
        NSLayoutConstraint.activate(calenderImageConstraint)
        NSLayoutConstraint.activate(joinDateConstraint)
        NSLayoutConstraint.activate(followingCountConstraint)
        NSLayoutConstraint.activate(followingLabelConstraint)
        NSLayoutConstraint.activate(followerCountConstraint)
        NSLayoutConstraint.activate(followerLabelConstraint)
        NSLayoutConstraint.activate(sectionStackConstraint)
        NSLayoutConstraint.activate(indicatorConstraint)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

}
