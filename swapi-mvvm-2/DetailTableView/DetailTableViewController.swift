//
//  DetailTableViewControllerDiff.swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 23.05.2023.
//

import UIKit
class DetailTableViewController: UIViewController, UITableViewDelegate, InfoViewModelDelegate {
    
    var viewModel: DetailTableViewControllerViewModel
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
        
        func intoContentType() -> ContentType? {
            switch self {
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
    
    init(viewModel: DetailTableViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTableView()
        setupDataSource()
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addItemToSnapshot(type: ContentType, item: EntityViewModel) {
        
        var snapshot = dataSource.snapshot()
    
        
        // Checking if snapshot of datasource has a section for item, if not - adding the section
        
        if !snapshot.sectionIdentifiers.contains(type.intoSectionType()) {
            snapshot.appendSections([type.intoSectionType()])
        }
        
        //  Applying to dataSource
        
        snapshot.appendItems([item], toSection: type.intoSectionType())
        dataSource.apply(snapshot)
    }
    
    
    //    Generating header for section according to viewmodel's textForHeaderInSection text
    
    func generateHeaderForSection(section: Section) -> UITableViewHeaderFooterView {
        let header = UITableViewHeaderFooterView(reuseIdentifier: "header")
        var content = UIListContentConfiguration.sidebarHeader()
        content.text = viewModel.textForHeaderInSection(section: section)
        header.contentConfiguration = content
        return header
    }
    
    
    // Checking if section's header should be displayed
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionIdentifier = dataSource.sectionIdentifier(for: section) else { return nil }
        guard viewModel.displayHeaderForSection(section: sectionIdentifier) else { return nil}
        return generateHeaderForSection(section: sectionIdentifier)
    }
    
        
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        title = viewModel.titleForTableView
        tableView.delegate = self
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource <Section, EntityViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, entity in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)
            cell?.accessoryType = .disclosureIndicator
            var content = cell?.defaultContentConfiguration()
            
            if self.dataSource.sectionIdentifier(for: indexPath.section) == .main {
                cell?.accessoryType = .none
                cell?.selectionStyle = .none
            } else {
                content?.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            }
            
            content?.text = entity.name
            cell?.contentConfiguration = content
            return cell
        })
        dataSource.defaultRowAnimation = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, EntityViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems([EntityViewModel(name: viewModel.giveDescription(), url: "noturl")], toSection: .main)
        
        DispatchQueue.global().async {
            self.dataSource.apply(snapshot)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        canMoveToNextViewController = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard canMoveToNextViewController == true else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath), let sectionType = dataSource.sectionIdentifier(for: indexPath.section), let contentType = sectionType.intoContentType() else { return }
        
        Generator.generateViewModelHelper(url: item.url, contentType: contentType, responseType: contentType.intoNetworkResponseType()) { [weak self] viewModel in
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {
                
                let vc = DetailTableViewController(viewModel: viewModel)
                
                guard self?.canMoveToNextViewController == true else {return}
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.canMoveToNextViewController = false
            }
        }
    }
}
