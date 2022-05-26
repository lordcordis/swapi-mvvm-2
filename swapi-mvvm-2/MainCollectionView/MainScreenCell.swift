//
//  CollectionViewCell.swift
//  SWAPI-MVVM
//
//  Created by Wheatley on 18.05.2022.
//

import UIKit

class MainScreenCell: UICollectionViewCell {
    
    let headlineLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headlineLabel)

        headlineLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        headlineLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        headlineLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        headlineLabel.adjustsFontForContentSizeCategory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
