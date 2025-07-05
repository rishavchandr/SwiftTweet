//
//  ProfileViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 05/07/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let tableHeader = ProfileHeaderView()
    
    let profileTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        tableHeader.frame =  CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380)
        profileTableView.tableHeaderView = tableHeader
       // configureProfileConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileTableView.frame = view.bounds
    }
}

extension ProfileViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as?
                TweetTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        return cell
    }
    
    
}

extension ProfileViewController: tweetTableViewCellDelegate {
    func didTapToReplyButton() {
        
    }
    
    func didTapToRetweetButton() {
        
    }
    
    func didTapToLikeButton() {
        
    }
    
    func didTapToShareButton() {
        
    }
}
