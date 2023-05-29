//
//  DetailTableViewControllerDiff.swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 23.05.2023.
//

import UIKit
class DetailTableViewControllerDiff: UIViewController, UITableViewDelegate, InfoViewModelDelegate {
    
    var viewModel: InfoViewModel
    var dataSource: UITableViewDiffableDataSource<Section, EntityViewModel>! = nil
    var tableView: UITableView! = nil
    let cellID = "DetailTableViewControllerDiff"
    var canMoveToNextViewController = true
    
    enum Section: CaseIterable {
        case main
        case Films
        case People
        case Planets
        case Species
        case Starships
        case Vehicles
        
        
        static func convertSectionIntoContentType(_ type: Section) -> ContentType? {
            switch type {
            case .main:
                return nil
            case .Films:
                return .Films
            case .People:
                return .People
            case .Planets:
                return .Planets
            case .Species:
                return .Species
            case .Starships:
                return .Starships
            case .Vehicles:
                return .Vehicles
            }
        }
    }
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTableView()
        setupDataSource()
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .separator
    }
    
    func addItemToSnapshot(type: ContentType, item: EntityViewModel) {
        var snapshot = dataSource.snapshot()
        let sectionTypeToAdd = ContentType.convertContentTypeIntoSectionType(type: type)
        
        
        if !snapshot.sectionIdentifiers.contains(sectionTypeToAdd) {
            snapshot.appendSections([sectionTypeToAdd])
            
        }
        
        switch type {
        case .Films:
            snapshot.appendItems([item], toSection: .Films)
        case .People:
            snapshot.appendItems([item], toSection: .People)
        case .Planets:
            snapshot.appendItems([item], toSection: .Planets)
        case .Species:
            snapshot.appendItems([item], toSection: .Species)
        case .Starships:
            snapshot.appendItems([item], toSection: .Starships)
        case .Vehicles:
            snapshot.appendItems([item], toSection: .Vehicles)
        }
        
        dataSource.apply(snapshot)
        
        
    }
    
    func generateHeaderForSection(section: Section) -> UITableViewHeaderFooterView {
        let header = UITableViewHeaderFooterView(reuseIdentifier: "header")
        var content = header.defaultContentConfiguration()
        content.text = viewModel.textForHeaderInSection(section: section)
        header.contentConfiguration = content
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionIdentifier = dataSource.sectionIdentifier(for: section)!
        guard viewModel.displayHeaderForSection(section: sectionIdentifier) else { return nil}
        return generateHeaderForSection(section: sectionIdentifier)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        title = viewModel.name
        tableView.delegate = self
        
    }
    
    func setupDataSource() {
        
        dataSource = UITableViewDiffableDataSource <Section, EntityViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, entity in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)
            cell?.accessoryType = .disclosureIndicator
            
            let section = self.dataSource.sectionIdentifier(for: indexPath.section)
            if section == .main {
                cell?.accessoryType = .none
                cell?.selectionStyle = .none
            }
            
            var content = cell?.defaultContentConfiguration()
            content?.text = entity.name
            cell?.contentConfiguration = content
            return cell
        })
        dataSource.defaultRowAnimation = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, EntityViewModel>()
        snapshot.appendSections([.main])
        
//        switch viewModel.contentType {
//        case .Films:
//            snapshot.appendSections([.main, .People, .Planets, .Species, .Vehicles])
//        case .People:
//            snapshot.appendSections([.main, .Films, .Planets, .Species, .Vehicles])
//        case .Planets:
//            snapshot.appendSections([.main, .Films, .People])
//        case .Species:
//            snapshot.appendSections([.main, .Films, .People, .Planets])
//        case .Starships:
//            snapshot.appendSections([.main, .Films, .People, .Planets, .Species, .Vehicles])
//        case .Vehicles:
//            snapshot.appendSections([.main, .Films, .People, .Planets, .Species, .Starships])
//        }
        
//        for sectionToCheck in Section.allCases {
//            if viewModel.isSectionEmpty(section: sectionToCheck) {
//                snapshot.appendSections([sectionToCheck])
//            }
//        }
        
        
        
        
        
        snapshot.appendItems([EntityViewModel(name: viewModel.giveDescription(), url: "noturl")], toSection: .main)
        
        let backgroundQueue = DispatchQueue(label: "background", qos: .background)
        backgroundQueue.async {
            self.dataSource.apply(snapshot)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        canMoveToNextViewController = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard canMoveToNextViewController == true else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let sectionType = dataSource.sectionIdentifier(for: indexPath.section)!
//        guard let contentType = sectionType.sectionIntoContentType(sectionType) else {return}
        guard let contentType = Section.convertSectionIntoContentType(sectionType) else {return}
        let responseType: NetworkResponse.Type = ContentType.convertContentTypeIntoNetworkResponseType(for: contentType)
        
        
        
        
        
        Generator.generateViewModelHelper(url: item.url, contentType: contentType, responseType: responseType.self) { [weak self] viewModel in
                        guard let viewModel = viewModel else { return }
                        DispatchQueue.main.async {
                            let vc = DetailTableViewControllerDiff(viewModel: viewModel)


                            if self?.canMoveToNextViewController == true {
                                self?.navigationController?.pushViewController(vc, animated: true)
                                self?.canMoveToNextViewController = false
                            } else {
                                return
                            }
                        }
                    }
        
        
//        switch sectionType {
//        case .Films:
//            Generator.generateViewModelHelper(url: item.url, contentType: .Films, responseType: FilmNetworkResponse.self) { [weak self] viewModel in
//                guard let viewModel = viewModel else { return }
//                DispatchQueue.main.async {
//                    let vc = DetailTableViewControllerDiff(viewModel: viewModel)
//
//
//                    if self?.canMoveToNextViewController == true {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        self?.canMoveToNextViewController = false
//                    } else {
//                        return
//                    }
//                }
//            }
//
//
//
//        case .none:
//            fatalError()
//        case .some(.main):
//            return
//        case .People:
//            Generator.generateViewModelHelper(url: item.url, contentType: .People, responseType: PersonNetworkResponse.self) {
//
//                [weak self] viewModel in
//                guard let viewModel = viewModel else { return }
//                DispatchQueue.main.async {
//                    let vc = DetailTableViewControllerDiff(viewModel: viewModel)
////                    vc.viewModel = viewModel
//
//
//                    if self?.canMoveToNextViewController == true {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        self?.canMoveToNextViewController = false
//                    } else {
//                        return
//                    }
//                }
//            }
//        case .Planets:
//            Generator.generateViewModelHelper(url: item.url, contentType: .Planets, responseType: PlanetNetworkResponse.self) { [weak self] viewModel in
//                guard let viewModel = viewModel else { return }
//                DispatchQueue.main.async {
//                    let vc = DetailTableViewControllerDiff(viewModel: viewModel)
////                    vc.viewModel = viewModel
//
//
//                    if self?.canMoveToNextViewController == true {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        self?.canMoveToNextViewController = false
//                    } else {
//                        return
//                    }
//                }
//            }
//        case .Species:
//            Generator.generateViewModelHelper(url: item.url, contentType: .Species, responseType: SpeciesNetworkResponse.self) { [weak self] viewModel in
//                guard let viewModel = viewModel else { return }
//                DispatchQueue.main.async {
//                    let vc = DetailTableViewControllerDiff(viewModel: viewModel)
////                    vc.viewModel = viewModel
//
//
//                    if self?.canMoveToNextViewController == true {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        self?.canMoveToNextViewController = false
//                    } else {
//                        return
//                    }
//                }
//            }
//        case .Starships:
//            Generator.generateViewModelHelper(url: item.url, contentType: .Starships, responseType: StarshipNetworkResponse.self) { [weak self] viewModel in
//                guard let viewModel = viewModel else { return }
//                DispatchQueue.main.async {
//                    let vc = DetailTableViewControllerDiff(viewModel: viewModel)
////                    vc.viewModel = viewModel
//
//
//                    if self?.canMoveToNextViewController == true {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        self?.canMoveToNextViewController = false
//                    } else {
//                        return
//                    }
//                }
//            }
//        case .Vehicles:
//            Generator.generateViewModelHelper(url: item.url, contentType: .Vehicles, responseType: VehicleNetworkResponse.self) { [weak self] viewModel in
//                guard let viewModel = viewModel else { return }
//                DispatchQueue.main.async {
//                    let vc = DetailTableViewControllerDiff(viewModel: viewModel)
////                    vc.viewModel = viewModel
//
//
//                    if self?.canMoveToNextViewController == true {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        self?.canMoveToNextViewController = false
//                    } else {
//                        return
//                    }
//                }
//            }
//        }
        
    }
}
