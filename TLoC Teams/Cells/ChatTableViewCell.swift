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
    
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    public func setupUI() {
        
    }
    
    // MARK: - Configure
    
    public func configure(with item: Message?) {
        
        textLabel?.text = item?.text
    }
}
