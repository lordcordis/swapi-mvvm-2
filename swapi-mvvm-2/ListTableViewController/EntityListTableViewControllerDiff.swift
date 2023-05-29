//
//  DetailTableViewController(Diff).swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 22.05.2023.
//

import UIKit

class EntityListTableViewControllerDiff: UIViewController, UITableViewDelegate {
    
    let cellID = "EntityListTableViewControllerDiff"
    
    
    enum Section: String, CaseIterable {
        case main
    }
    
    var viewModel: EntityListViewModelProtocol
    var dataSource: UITableViewDiffableDataSource<Section, EntityViewModel>! = nil
    var tableView: UITableView! = nil
    
    
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
    }
    
    func setupTitle() {
        switch viewModel.contentType {
        case .People:
            title = "People"
        case .Planets:
            title = "Planets"
        case .Starships:
            title = "Starships"
        case .Species:
            title = "Species"
        case .Vehicles:
            title = "Vehicles"
        case .Films:
            title = "Films"
        }
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        tableView.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.entitiesArray.count - 1 {
            EntityListViewModel.createEntityListViewModel(url: viewModel.nextUrl ?? "", type: viewModel.contentType) {  result in
                self.viewModel.nextUrl = result.nextUrl ?? nil
                
                //                checking data source for duplicates
                
                if !self.viewModel.entitiesArray.contains(result.entitiesArray) {
                    self.viewModel.entitiesArray.append(contentsOf: result.entitiesArray)
                    
                    var snapshot = self.dataSource.snapshot()
                    snapshot.appendItems(result.entitiesArray, toSection: .main)
                    
                    let backgroundQueue = DispatchQueue(label: "background", qos: .background)
                    backgroundQueue.async {
                        self.dataSource.apply(snapshot)
                    }
                    
                    
                    
                }
            }
        }
    }
    
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource <Section, EntityViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, entity in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)
            cell?.accessoryType = .disclosureIndicator
            var content = cell?.defaultContentConfiguration()
            content?.text = entity.name
            cell?.contentConfiguration = content
            return cell
        })
        
        
        //        dataSource.tableView(tableView, titleForFooterInSection: 1)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, EntityViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.entitiesArray, toSection: .main)
        print(snapshot.sectionIdentifiers)
        
        
        let backgroundQueue = DispatchQueue(label: "background", qos: .background)
        backgroundQueue.async {
            self.dataSource.apply(snapshot)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.generateViewModel(indexPath: indexPath, viewModel: self.viewModel) { [weak self] viewModelExport in
            guard let viewModelExport = viewModelExport else { return }
            DispatchQueue.main.async {
                let vc = DetailTableViewControllerDiff(viewModel: viewModelExport)
//                vc.viewModel = viewModelExport
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    
    
}

