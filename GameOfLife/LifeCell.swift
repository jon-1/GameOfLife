//
//  LifeCell.swift
//  GameOfLife
//
//  Created by Jon Michael on 7/23/18.
//  Copyright © 2018 Jon Michael. All rights reserved.
//

import Foundation
import UIKit

class LifeCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "LifeCell"
    
    // MARK: - Properties
    
    override func prepareForReuse() {
        backgroundColor = .clear
    }
}
