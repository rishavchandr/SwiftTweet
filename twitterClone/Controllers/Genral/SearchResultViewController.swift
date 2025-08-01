//
//  SearchResultViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 31/07/25.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var users: [TweetUser] = []
    
    private let searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultTableView)
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        configureConstraint()
    }
    
    private func configureConstraint() {
        
        let searchResultTableViewConstraint = [
            searchResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchResultTableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        
        NSLayoutConstraint.activate(searchResultTableViewConstraint)
    }
    
    func update(users: [TweetUser]){
        self.users = users
        DispatchQueue.main.async { [weak self] in
            self?.searchResultTableView.reloadData()
        }
    }

}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let profileViewModel = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        present(vc, animated: true)
    }
    
}
