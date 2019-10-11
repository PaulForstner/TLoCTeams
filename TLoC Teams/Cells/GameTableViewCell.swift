//
//  GameTableViewCell.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 02.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    
    // MARK: - Configure
    
    public func configure(with item: Game?) {
        
        gameNameLabel.text = item?.name
    }
}

// MARK: - ImageLoadable

extension GameTableViewCell: ImageLoadable {
    
    var imageLoadableView: UIImageView {
        return gameImageView
    }
}
