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
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero, collectionViewLayout: UICollectionViewLayout) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        updateColors()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getMainColor() : colorStyle.getAlternativeColors()
        updateSubviewsColors()
        
        if self.numberOfSections >= 0 {
            let numberOfSections = self.numberOfSections - 1
            if numberOfSections >= 0 {
                for i in 0...numberOfSections {
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
