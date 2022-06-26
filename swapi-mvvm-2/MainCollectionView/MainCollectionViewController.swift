//
//  MainCollectionViewController.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import UIKit


class MainCollectionViewController: UICollectionViewController {
    
    var viewModel: MainCollectionViewControllerViewModelProtocol!
    
    var canMoveToNextViewController = true
    
    override func viewWillAppear(_ animated: Bool) {
        canMoveToNextViewController = true
        title = "SWAPI"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainCollectionViewControllerViewModel(completion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
        
        
        self.collectionView!.register(MainScreenCell.self, forCellWithReuseIdentifier:  Keys.mainScreenCellIdentificator)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.buttonNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = viewModel.buttonNames[indexPath.row]
        guard let contentType = ContentType.init(rawValue: type) else {return}
                EntityListViewModel.createEntityListViewModel(url: viewModel.buttonURLs[indexPath.row], type: contentType, completion: { [weak self] result in
                    guard let self = self else {return}
                    DispatchQueue.main.async {
                        let vm = EntityListTableViewController(style: .plain)
                        vm.viewModel = result
                        print(vm.viewModel.nextUrl)
                        if self.canMoveToNextViewController {
                            self.navigationController?.pushViewController(vm, animated: true)
                            self.canMoveToNextViewController = false
                        } else {
                            return
                        }
                    }
                })
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.mainScreenCellIdentificator, for: indexPath) as! MainScreenCell
        cell.backgroundColor = .systemPink
        cell.layer.cornerRadius = 10
        cell.headlineLabel.text = viewModel.textForButton(at: indexPath.row)
        return cell
    }
}
