//
//  ListTableViewController.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import UIKit

class EntityListTableViewController: UITableViewController {
    
    var viewModel: EntityListViewModelProtocol! {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tintColor = .systemPink
        
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Keys.listTableViewCellId)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.array.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.listTableViewCellId, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.textFor(indexPath: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        
//        if #available(iOS 16.0, *) {
//            cell.contentConfiguration = UIHostingConfiguration {
//                HStack {
//                    Spacer()
//                    Text(Date(), style: .date).foregroundStyle(.secondary).font(.footnote)
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.array.count - 1 {
            EntityListViewModel.createEntityListViewModel(url: viewModel.nextUrl ?? "", type: viewModel.contentType) { result in
                self.viewModel.nextUrl = result.nextUrl ?? nil
                
//                checking data source for duplicates
                
                if !self.viewModel.array.contains(result.array) {
                    self.viewModel.array.append(contentsOf: result.array)
                    self.viewModel.urlArray.append(contentsOf: result.urlArray)
                }
            }
        }
    }
    
    func deselectRow(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath)
        
        viewModel.generateViewModel(indexPath: indexPath, viewModel: self.viewModel) { viewModelExport in
            guard let viewModelExport = viewModelExport else {
                return
            }
            DispatchQueue.main.async {
                let vc = DetailTableViewController(style: .insetGrouped)
                vc.viewModel = viewModelExport
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
