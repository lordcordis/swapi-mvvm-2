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
        
        switch viewModel.contentType {
        case .People:
            title = "People"
        case .Planets:
            title = "Planets"
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Keys.listTableViewCellId)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.listTableViewCellId, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.array[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.array.count - 1 {
            print("end of array")
            EntityListViewModel.createViewModel(url: viewModel.nextUrl, type: viewModel.contentType) { result in
                self.viewModel.array.append(contentsOf: result.array)
                self.viewModel.urlArray.append(contentsOf: result.urlArray)
//                print(self.viewModel.array.count)
                self.viewModel.nextUrl = result.nextUrl
//                print(self.viewModel.nextUrl)
                
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print(viewModel.urlArray[indexPath.row])
    }
    
}
