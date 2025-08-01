//
//  SearchViewController.swift
//  twitterClone
//
//  Created by Rishav chandra on 26/06/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search with @username"
        return searchController
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "Try searching for people list or keybwords"
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .placeholderText
        label.textAlignment = .center
        return label
    }()
    
    let viewModel: SearchviewViewModel

    init(viewModel: SearchviewViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(promptLabel)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        configureConstraint()

    }
    
    private func configureConstraint() {
        let promptLabelConstaints = [
            promptLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            promptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(promptLabelConstaints)
    }


}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultViewController = searchController.searchResultsController as? SearchResultViewController ,
                let query = searchController.searchBar.text else { return }
        
        viewModel.search(with: query) { users in
            resultViewController.update(users: users)
        }
    }
}
