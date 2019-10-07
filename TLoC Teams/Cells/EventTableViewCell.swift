//
//  EventTableViewCell.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 03.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Lazy
    
    private lazy var locationLabel: UILabel = {
        return createLabel()
    }()
    
    private lazy var gameLabel: UILabel = {
        return createLabel()
    }()
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    public func setupUI() {
        
        eventImageView.layer.cornerRadius = 12
        eventImageView.contentMode = .scaleAspectFill
        eventNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        selectionStyle = .none
        
        #warning("REMOVE")
        eventImageView.image = Asset.paul.image
    }
    
    // MARK: - Configure
    
    public func configure(with item: Event?) {
        
        dateLabel.text = item?.date
        eventNameLabel.text = item?.name
        
        if let game = item?.game {
            gameLabel.text = game.name
            stackView.addArrangedSubview(gameLabel)
        }
        
        if let location = item?.location {
            locationLabel.text = location.name
            stackView.addArrangedSubview(locationLabel)
        }
        
        setImage(with: item?.imageUrl)
    }
    
    // MARK: - Helper
    
    private func setImage(with urlString: String?) {
        
        
    }
    
    private func createLabel() -> UILabel {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = ColorName.gray.color
        return label
    }
}
