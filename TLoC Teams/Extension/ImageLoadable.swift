//
//  ImageLoadable.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 10.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ImageLoadable {

    var imageLoadableView: UIImageView { get }

    func cancel()
    func loadImage(url: URL?, placeholderImage: UIImage?)
}

extension ImageLoadable {

    func cancel() {
        self.imageLoadableView.af_cancelImageRequest()
    }

    func loadImage(url: URL?, placeholderImage: UIImage?) {

        self.cancel()
        guard let url = url else {
            return
        }

        self.imageLoadableView.af_setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true)
    }
}
