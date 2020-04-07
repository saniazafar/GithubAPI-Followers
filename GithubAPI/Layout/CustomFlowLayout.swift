//
//  CustomFlowLayout.swift
//  GithubAPI
//
//  Created by sania zafar on 10/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    private let numberOfColumns = 3
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            
            return 0
        }
        let insets = self.sectionInset
        
        return collectionView.bounds.width - (insets.left + insets.right) - 20.0
    }
    
    override var itemSize: CGSize {
        set {}
        get {
            let cellWidth = (contentWidth - (minimumInteritemSpacing * CGFloat(numberOfColumns - 1))) / CGFloat(numberOfColumns)
            
            return CGSize(width: cellWidth, height: 140)
        }
    }
    
}
