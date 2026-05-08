//
//  DetailTableViewController(Diff).swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 22.05.2023.
//

import UIKit

class EntityListTableViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let cellID = "EntityListTableViewControllerDiff"

    
    
    enum Section: String, CaseIterable {
        case main
    }
    
    var viewModel: EntityListViewModelProtocol
    var dataSource: UITableViewDiffableDataSource<Section, EntityViewModel>! = nil
    var tableView: UITableView = UITableView()
    
    
    init(viewModel: EntityListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupTableView()
        setupDataSource()
        configureNavigationController()
        loadAllPages {}
    }
    
    func setupTitle() {
        switch viewModel.contentType {
        case .People:
            title = String(localized: "People")
        case .Planets:
            title = String(localized: "Planets")
        case .Starships:
            title = String(localized: "Starships")
        case .Species:
            title = String(localized: "Species")
        case .Vehicles:
            title = String(localized: "Vehicles")
        case .Films:
            title = String(localized: "Films")
        }
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        tableView.delegate = self
    }
    
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource <Section, EntityViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, entity in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)
            cell?.accessoryType = .disclosureIndicator
            var content = cell?.defaultContentConfiguration()
            content?.text = entity.name
            content?.textProperties.font = .preferredFont(forTextStyle: .body)
            content?.image = UIImage(systemName: self.viewModel.contentType.iconName)
            content?.imageProperties.tintColor = .systemYellow
            cell?.contentConfiguration = content
            return cell
        })
        
        
        //        dataSource.tableView(tableView, titleForFooterInSection: 1)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, EntityViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.entitiesArray, toSection: .main)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else {return}
        
        viewModel.generateViewModelHelperDiff(entity: item, viewModel: self.viewModel) { [weak self] viewModelExport in
                       guard let viewModelExport = viewModelExport else { return }
                       DispatchQueue.main.async {
                           let vc = DetailTableViewController(viewModel: viewModelExport)
                           self?.navigationController?.pushViewController(vc, animated: true)
                       }
                   }
            
        }

    
    func loadAllPages(completion: @escaping () -> Void) {
        guard let nextUrl = viewModel.nextUrl, !nextUrl.isEmpty else {
            completion()
            return
        }

        EntityListViewModel.createEntityListViewModel(url: nextUrl, type: viewModel.contentType) { result in
            self.viewModel.nextUrl = result.nextUrl
            self.viewModel.entitiesArray.append(contentsOf: result.entitiesArray)

            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(result.entitiesArray, toSection: .main)

            DispatchQueue.main.async {
                self.dataSource.apply(snapshot)
            }

            self.loadAllPages(completion: completion)
        }
    }

    @objc func sortItemsAlpahetically() {
        navigationItem.rightBarButtonItem?.isEnabled = false

        loadAllPages { [weak self] in
            guard let self else { return }

            var snapshot = self.dataSource.snapshot()
            let items = snapshot.itemIdentifiers(inSection: .main)
            snapshot.deleteItems(items)
            let sorted = items.sorted { $0.name < $1.name }
            snapshot.appendItems(sorted, toSection: .main)

            DispatchQueue.main.async {
                self.dataSource.apply(snapshot)
            }
        }
    }

    func configureNavigationController() {
        let sortItemsBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .done, target: self, action: #selector(sortItemsAlpahetically))
        navigationItem.rightBarButtonItem = sortItemsBarButton

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "Search")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        let items = viewModel.entitiesArray

        var snapshot = NSDiffableDataSourceSnapshot<Section, EntityViewModel>()
        snapshot.appendSections([.main])

        if query.isEmpty {
            snapshot.appendItems(items, toSection: .main)
        } else {
            let filtered = items.filter { $0.name.localizedCaseInsensitiveContains(query) }
            snapshot.appendItems(filtered, toSection: .main)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
