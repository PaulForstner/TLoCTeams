//
//  ChatTableViewCell.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 17.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var groupImageView: UIImageView!
    @IBOutlet private weak var groupNameLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    public func setupUI() {
        
        groupImageView.layer.cornerRadius = groupImageView.frame.height / 2
        groupImageView.contentMode = .scaleAspectFill
        groupNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        senderLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = ColorName.gray.color
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        selectionStyle = .none
    }
    
    // MARK: - Configure
    
    public func configure(with item: Chat?) {
        
        groupNameLabel.text = item?.name
        let firstMessage = item?.messages.first
        
        let sender = firstMessage?.sender
        if var sender = sender {
            sender += ": "
        }
        
        senderLabel.text = sender
        messageLabel.text = firstMessage?.text ?? "..."
        dateLabel.text = firstMessage?.date
    }
}

// MARK: - ImageLoadable

extension ChatTableViewCell: ImageLoadable {
    
    var imageLoadableView: UIImageView {
        return groupImageView
    }
}
