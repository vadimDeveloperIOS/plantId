//
//  TabBarItem.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit


public protocol TabBarItem {
    var image: UIImage? { get }
    var selectedImage: UIImage? { get }
}

public struct RegularTabBarItem: TabBarItem {
    public var image: UIImage?
    public var selectedImage: UIImage?

    public init(image: UIImage?, selectedImage: UIImage?) {
        self.image = image
        self.selectedImage = selectedImage
    }
}
