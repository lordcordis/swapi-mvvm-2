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
        label.text = """
        SWAPI is down / Your connection is offline
        Pull down to refresh
        """
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
        title = "SWAPI: A Star Wars API"
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
        applySnapshot(snapshot)
    }
    
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<MainCollectionViewController.Section, EntityViewModel>) {
        DispatchQueue.global().async {
            self.dataSource.apply(snapshot)
        }
    }
    
    func initialiseViewModel() {
        
        DispatchQueue.global().async {
            self.resetDataSource()
        }
        
        viewModel = MainCollectionViewControllerViewModel(completion: { [weak self] result in
            switch result {
                
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async {
                    self?.maximiseNetworkingErrorView()
                }
                
            case .success (let initialArrayOfItems):
                
                DispatchQueue.main.async {
                    self?.minimiseNetworkingErrorView()
                }
                
                guard let array = initialArrayOfItems, var snapshot = self?.dataSource.snapshot() else {return}
                snapshot.appendItems(array, toSection: .main)
                self?.applySnapshot(snapshot)
                
            case .none:
                fatalError()
            }
        })
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
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
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
        DispatchQueue.global().async {
            self.dataSource.apply(snapshot)
        }
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let type = dataSource.itemIdentifier(for: indexPath)?.name,
              let url = dataSource.itemIdentifier(for: indexPath)?.url,
              let contentType = ContentType.init(rawValue: type.capitalized) else {return}
        print(type)
        print(contentType)
        EntityListViewModel.createEntityListViewModel(url: url, type: contentType, completion: { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                let vm = EntityListTableViewController(viewModel: result)
                if self.canMoveToNextViewController {
                    self.navigationController?.pushViewController(vm, animated: true)
                    self.canMoveToNextViewController = false
                } else {
                    return
                }
            }
        })
    }
}
