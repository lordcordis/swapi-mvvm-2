//
//  MainCollectionViewController + ErrorView.swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 02.06.2023.
//

import UIKit

extension MainCollectionViewController {
    
    func maximiseNetworkingErrorView() {
        guard isErrorViewShown == false else {return}
        collectionView.addSubview(errorView)
        isErrorViewShown = true
    }
    
    
    func minimiseNetworkingErrorView() {
        guard isErrorViewShown == true else {return}
        let view = collectionView.subviews.last
        view?.removeFromSuperview()
        isErrorViewShown = false
    }
    
}
