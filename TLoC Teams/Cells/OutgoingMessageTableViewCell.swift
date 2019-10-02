//
//  OutgoingMessageTableViewCell.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 26.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var messageTextLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    public func setupUI() {
        
        selectionStyle = .none
        
        containerView.layer.cornerRadius = 12
        messageTextLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = ColorName.gray.color
        
        containerView.backgroundColor = ColorName.lightGreen.color.withAlphaComponent(0.5)
    }
    
    // MARK: - Configure
    
    public func configure(with item: Message?) {
        
        messageTextLabel.text = item?.text
        dateLabel.text = item?.date
    }
}
