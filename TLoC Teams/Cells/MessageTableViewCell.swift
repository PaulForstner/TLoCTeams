//
//  MessageTableViewCell.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 23.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var messageTextLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    
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
        senderLabel.font = UIFont.boldSystemFont(ofSize: 16)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = ColorName.gray.color
        
        containerView.backgroundColor = ColorName.lightGray.color.withAlphaComponent(0.5)
    }
    
    // MARK: - Configure
    
    public func configure(with item: Message?) {
        
        messageTextLabel.text = item?.text
        dateLabel.text = item?.date
        senderLabel.text = item?.sender
    }
}
