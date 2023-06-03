//
//  UICollectionView+Extensions.swift
//  Tracker-ios
//
//  Created by Илья Валито on 05.05.2023.
//

import UIKit

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}
