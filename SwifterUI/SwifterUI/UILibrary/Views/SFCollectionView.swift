//
//  SFCollectionView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionView: UICollectionView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, collectionViewLayout: UICollectionViewLayout) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.mainColor : colorStyle.alternativeColor
        updateSubviewsColors()
        
        if self.numberOfSections >= 0 {
            let numberOfSections = self.numberOfSections - 1
            if numberOfSections >= 0 {
                for i in 0...numberOfSections {
                    
                    if let header = supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: i)) as? SFViewColorStyle {
                        header.updateColors()
                    }
                    
                    if let footer = supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: i)) as? SFViewColorStyle {
                        footer.updateColors()
                    }
                    
                    let numberOfItems = self.numberOfItems(inSection: i) - 1
                    if numberOfItems > 0 {
                        for j in 0...numberOfItems {
                            guard let cell = cellForItem(at: IndexPath(row: j, section: i)) as? SFCollectionViewCell else { return }
                            cell.updateColors()
                        }
                    }
                }
            }
        }
    }
    
    open override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? SFCollectionViewCell {
            cell.updateColors()
        }
        return cell
    }
}
