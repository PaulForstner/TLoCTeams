//
//  StoryboardInitializable.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

protocol StoryboardInitializable where Self: UIViewController {
    
    static func makeFromStoryboard() -> Self
}
