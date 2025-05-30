//
//  UICollectionViewCell+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2025/5/26.
//

import UIKit

extension UIResponder {
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UICollectionViewCell {
    static var cellIdentifier: String {
        typeName
    }

    var crs_collectionView: UICollectionView? {
        return parentView(of: UICollectionView.self)
    }

    func crs_reloadCell() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        if let collectionView = crs_collectionView {
            if let indexPath = collectionView.indexPath(for: self) {
                collectionView.crs_reloadRows(at: [indexPath])
            }
        }
        CATransaction.commit()
    }

    var crs_indexPath: IndexPath? {
        return next(UICollectionView.self)?.indexPath(for: self)
    }
}
