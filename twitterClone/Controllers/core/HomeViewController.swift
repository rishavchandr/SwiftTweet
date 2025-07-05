//
//  HomeViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 26/06/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
        
    }
    
    @objc func didTapProfile(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath)
                as? TweetTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        
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
