//
//  TestTableViewController.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import UIKit

 class DetailTableViewController: UITableViewController, InfoViewModelDelegate {
    
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
     var viewModel: InfoViewModel?
//     {
//         didSet{
//             updateView()
//         }
//     }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel?.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Keys.detailViewInfoCell)
        title = viewModel?.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowsInSection(section: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.detailViewInfoCell, for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            config.text = viewModel?.giveDescription()
        case 1:
            config.text = viewModel?.filmName(for: indexPath.row)
        case 2:
            config.text = viewModel?.residentName(for: indexPath.row)
        case 3:
            config.text = viewModel?.planetName(for: indexPath.row)
        case 4:
            config.text = viewModel?.vehicleName(for: indexPath.row)
        default:
            config.text = "test"
        }
        
        
        
        
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.headerInSection(section: section)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: tableView.deselectRow(at: indexPath, animated: false)
        case 1:
//            print("selected")
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            print("default")
        }
    }

}
