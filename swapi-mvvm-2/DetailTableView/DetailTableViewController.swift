//
//  DetailTableViewControllerDiff.swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 23.05.2023.
//

import UIKit
class DetailTableViewController: UIViewController, UITableViewDelegate {
    
    var viewModel: DetailTableViewControllerViewModel
    var dataSource: UITableViewDiffableDataSource<Section, EntityViewModel>! = nil
    var tableView: UITableView = UITableView()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            var content = cell?.defaultContentConfiguration()

            let section = self.dataSource.sectionIdentifier(for: indexPath.section)
            if section == .main {
                cell?.accessoryType = .none
                cell?.selectionStyle = .none
            } else {
                cell?.accessoryType = .disclosureIndicator
                content?.textProperties.font = .preferredFont(forTextStyle: .subheadline)
                if let contentType = section?.intoContentType() {
                    content?.image = UIImage(systemName: contentType.iconName)
                    content?.imageProperties.tintColor = .systemPink
                    content?.imageProperties.preferredSymbolConfiguration = .init(textStyle: .subheadline)
                }
            }

            content?.text = entity.name
            cell?.contentConfiguration = content
            return cell
        })
        dataSource.defaultRowAnimation = .none
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, EntityViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems([EntityViewModel(name: viewModel.giveDescription(), url: "noturl")], toSection: .main)

        let sectionData: [(ContentType, [EntityViewModel])] = [
            (.Films, viewModel.films),
            (.People, viewModel.residents),
            (.Planets, viewModel.planets),
            (.Species, viewModel.species),
            (.Starships, viewModel.starships),
            (.Vehicles, viewModel.vehicles),
        ]

        for (type, items) in sectionData where !items.isEmpty {
            snapshot.appendSections([type.intoSectionType()])
            snapshot.appendItems(items, toSection: type.intoSectionType())
        }

        dataSource.apply(snapshot)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        canMoveToNextViewController = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard canMoveToNextViewController else { return }
        tableView.deselectRow(at: indexPath, animated: true)

        guard let item = dataSource.itemIdentifier(for: indexPath),
              let sectionType = dataSource.sectionIdentifier(for: indexPath.section),
              let contentType = sectionType.intoContentType() else { return }

        Task {
            guard let viewModel = await Generator.generateViewModelHelper(url: item.url, contentType: contentType) else { return }
            guard canMoveToNextViewController else { return }
            let vc = DetailTableViewController(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
            canMoveToNextViewController = false
        }
    }
}
