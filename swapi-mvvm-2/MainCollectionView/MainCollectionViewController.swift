//
//  MainCollectionViewController.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import UIKit
import SwiftUI

final class MainCollectionViewController: UICollectionViewController {
    
    var isErrorViewShown: Bool = false
    
    var dataSource: UICollectionViewDiffableDataSource <Section, EntityViewModel>!
    
    var viewModel: MainCollectionViewControllerViewModelProtocol!
    
    var canMoveToNextViewController = true
    
    enum Section {
        case main
    }
    
    var errorView: UIView {
        let errorView = UIView(frame: collectionView.bounds)
        let roundedView = UIView()
        errorView.addSubview(roundedView)
        roundedView.backgroundColor = .systemBackground
        roundedView.layer.cornerRadius = 10
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = String(localized: "SWAPI is down / Your connection is offline\nPull down to refresh")
        errorView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: errorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            roundedView.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 20),
            roundedView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 20),
            roundedView.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            roundedView.centerYAnchor.constraint(equalTo: errorView.centerYAnchor)
        ])
        
        errorView.backgroundColor = .secondarySystemBackground
        return errorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        canMoveToNextViewController = true
        title = String(localized: "SWAPI: A Star Wars API")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(MainScreenCell.self, forCellWithReuseIdentifier:  Keys.mainScreenCellIdentificator)
        setupDataSource()
        initialiseViewModel()
        configureRefreshControl()
    }
    
    func resetDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot)
    }

    func initialiseViewModel() {
        resetDataSource()
        viewModel = MainCollectionViewControllerViewModel()
        Task {
            do {
                let entities = try await viewModel.getData()
                minimiseNetworkingErrorView()
                var snapshot = dataSource.snapshot()
                snapshot.appendItems(entities, toSection: .main)
                await dataSource.apply(snapshot)
            } catch {
                maximiseNetworkingErrorView()
            }
        }
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action:
                                                    #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        initialiseViewModel()
        collectionView.refreshControl?.endRefreshing()
    }
    
    
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource <Section, EntityViewModel>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.mainScreenCellIdentificator, for: indexPath) as! MainScreenCell
            cell.backgroundColor = .systemPink
            cell.layer.cornerRadius = 10
            cell.headlineLabel.text = item.name.capitalized
            return cell
        })
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot)
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath),
              let contentType = ContentType(rawValue: item.name.capitalized) else { return }

        Task {
            guard let result = await EntityListViewModel.createEntityListViewModel(url: item.url, type: contentType) else { return }
            guard canMoveToNextViewController else { return }
            let vc = EntityListTableViewController(viewModel: result)
            navigationController?.pushViewController(vc, animated: true)
            canMoveToNextViewController = false
        }
    }
}
