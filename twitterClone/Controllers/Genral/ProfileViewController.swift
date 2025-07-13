//
//  ProfileViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 05/07/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let tableHeader = ProfileHeaderView()
    
    private var isStatusBarHidden  = true
    
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
        view.backgroundColor = .black
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBarView)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        tableHeader.frame =  CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 400)
        profileTableView.tableHeaderView = tableHeader
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        configConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileTableView.frame = view.bounds
    }
    
    
    func configConstraint() {
        let statusBarContraint = [
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 50 : 30)
        ]
        
        NSLayoutConstraint.activate(statusBarContraint)
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
