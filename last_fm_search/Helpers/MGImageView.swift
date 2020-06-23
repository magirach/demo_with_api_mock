//
//  MGImageView.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 23/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func getImage(url: String, onLoad: @escaping (UIImage?) -> ()) {
        if let img = ImageCacheManager.shared.getImage(for: url) {
            return onLoad(img)
        } else {
            DispatchQueue.global(qos: .background).async {
                do {
                    guard let imageUrl = URL(string: url) else {
                        DispatchQueue.main.async {
                            onLoad(nil)
                        }
                        return
                    }
                    let data = try Data(contentsOf: imageUrl)
                    ImageCacheManager.shared.cacheImage(imageData: data, key: url)
                    let img = ImageCacheManager.shared.getImage(for:url)
                    DispatchQueue.main.async {
                        onLoad(img)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        onLoad(nil)
                    }
                }
            }
        }
    }
}

class MGImageView: UIImageView {
    
    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.color = .lightGray
        return indicator
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addSubview(loader)
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.layer.masksToBounds = true
        loader.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        loader.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    func setImage(url: String) {
        loader.startAnimating()
        UIImage.getImage(url: url) { [weak self] (image) in
            self?.image = image
            self?.loader.stopAnimating()
        }
    }
}

class ImageCacheManager: NSObject {
    
    static let shared:  ImageCacheManager = {
        return ImageCacheManager()
    }()
    
    private override init() {
        super.init()
    }
    
    private let cache = NSCache<AnyObject, AnyObject>()
    
    func cacheImage(imageData: Data, key: String) {
        cache.setObject(imageData as AnyObject, forKey: key as AnyObject)
    }
    
    func getImage(for key: String) -> UIImage? {
        if let imgData = cache.object(forKey: key as AnyObject) as? Data {
            return UIImage(data: imgData)
        } else {
            return nil
        }
    }
}
