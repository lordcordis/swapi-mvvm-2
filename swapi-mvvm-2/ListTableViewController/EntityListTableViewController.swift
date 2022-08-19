//
//  ListTableViewController.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import UIKit

class EntityListTableViewController: UITableViewController {
    
    var canMoveToNextVc: Bool = true
    
    var viewModel: EntityListViewModelProtocol! {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("viewModel changed: \(self.viewModel.entityArray.description)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        canMoveToNextVc = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return viewModel.entityArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.listTableViewCellId, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.textFor(indexPath: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.entityArray.count - 1 {
            viewModel.loadMore { model, string in
                self.viewModel.entityArray.append(contentsOf: model)
                guard let string = string else {return}
                self.viewModel.nextUrl = string
//                tableView.reloadData()
            }
//
//            viewModel.loadAdditional { res in
//                print("LOAD ADDITIONAL :\(res)")
//                self.viewModel.entityArray.append(contentsOf: res!)
//            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        viewModel.generateViewModel(indexPath: indexPath, viewModel: self.viewModel) { viewModelExport in
            guard let viewModelExport = viewModelExport else {
                return
            }
            
            guard self.canMoveToNextVc == true else { return }
            
            DispatchQueue.main.async {
                let vc = DetailTableViewController(model: viewModelExport, style: .plain)
//                vc.viewModel = viewModelExport
                self.navigationController?.pushViewController(vc, animated: true)
                self.canMoveToNextVc = false
            }
        }
    }
}
