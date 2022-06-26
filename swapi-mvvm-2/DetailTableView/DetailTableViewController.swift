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
     var canMoveToNextViewController = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel?.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Keys.detailViewInfoCell)
        title = viewModel?.name
    }
     
     override func viewWillAppear(_ animated: Bool) {
         canMoveToNextViewController = true
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
        case 5:
            config.text = viewModel?.speciesName(for: indexPath.row)
        case 6:
            config.text = viewModel?.starshipName(for: indexPath.row)
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
        
//        viewModel?.clear()
        
        guard canMoveToNextViewController == true else {return}
        
        switch indexPath.section {
        case 0: tableView.deselectRow(at: indexPath, animated: false)
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let viewModel = viewModel else {
                return
            }
            Generator.generateViewModelHelper(url: viewModel.filmURLArray[indexPath.row], contentType: .Films, responseType: FilmNetworkResponse.self) { viewModel in
                
                DispatchQueue.main.async {
                    let vc = DetailTableViewController(style: .insetGrouped)
                    vc.viewModel = viewModel
                    
                    
                    if self.canMoveToNextViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.canMoveToNextViewController = false
                    } else {
                        return
                    }
                    
                    
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.canMoveToNextViewController = false
                }
            }
        case 2:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let viewModel = viewModel else {
                return
            }
            Generator.generateViewModelHelper(url: viewModel.residentsURLArray[indexPath.row], contentType: .People, responseType: PersonNetworkResponse.self) { viewModel in
                
                DispatchQueue.main.async {
                    let vc = DetailTableViewController(style: .insetGrouped)
                    vc.viewModel = viewModel
                    
                    if self.canMoveToNextViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.canMoveToNextViewController = false
                    } else {
                        return
                    }
                    
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.canMoveToNextViewController = false
                }
            }
        case 3:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let viewModel = viewModel else {
                return
            }
            Generator.generateViewModelHelper(url: viewModel.planetURLArray[indexPath.row], contentType: .Planets, responseType: PlanetNetworkResponse.self) { viewModel in
                
                DispatchQueue.main.async {
                    let vc = DetailTableViewController(style: .insetGrouped)
                    vc.viewModel = viewModel
                    if self.canMoveToNextViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.canMoveToNextViewController = false
                    } else {
                        return
                    }
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.canMoveToNextViewController = false
                }
            }
        case 4:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let viewModel = viewModel else {
                return
            }
            Generator.generateViewModelHelper(url: viewModel.vehicleURLArray[indexPath.row], contentType: .Vehicles, responseType: VehicleNetworkResponse.self) { viewModel in
                
                DispatchQueue.main.async {
                    let vc = DetailTableViewController(style: .insetGrouped)
                    vc.viewModel = viewModel
                    if self.canMoveToNextViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.canMoveToNextViewController = false
                    } else {
                        return
                    }
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.canMoveToNextViewController = false
                }
            }
        case 5:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let viewModel = viewModel else {
                return
            }
            Generator.generateViewModelHelper(url: viewModel.speciesURLArray[indexPath.row], contentType: .Species, responseType: SpeciesNetworkResponse.self) { viewModel in
                
                DispatchQueue.main.async {
                    let vc = DetailTableViewController(style: .insetGrouped)
                    vc.viewModel = viewModel
                    if self.canMoveToNextViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.canMoveToNextViewController = false
                    } else {
                        return
                    }
                }
            }
        case 6:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let viewModel = viewModel else {
                return
            }
            Generator.generateViewModelHelper(url: viewModel.starshipsURLArray[indexPath.row], contentType: .Starships, responseType: StarshipNetworkResponse.self) { viewModel in
                
                DispatchQueue.main.async {
                    let vc = DetailTableViewController(style: .insetGrouped)
                    vc.viewModel = viewModel
                    if self.canMoveToNextViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.canMoveToNextViewController = false
                    } else {
                        return
                    }
                }
            }
        default:
            print("default")
        }
    }

}
