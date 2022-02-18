//
//  MyCollectionVCell.swift
//  FoodHub
//
//  Created by OPSolutions on 2/10/22.
//

import UIKit

class MyCollectionVCell: UICollectionViewCell {

  
    @IBOutlet weak var category: UIView!
    @IBOutlet weak var myWebSeriesLabel: UILabel!
    
    override var isSelected: Bool {
            didSet {
                category.backgroundColor = isSelected ? .systemGreen: .systemBackground
                myWebSeriesLabel.textColor = isSelected ? .systemBackground: .label
            }
        }
    
}
