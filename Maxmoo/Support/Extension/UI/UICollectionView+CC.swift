//
//  UICollectionView+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2025/5/26.
//

import UIKit

extension UICollectionView {
    
    func crs_reloadRows(at indexPaths: [IndexPath]) {
        if dataHasChanged {
            reloadData()
        } else {
            reloadItems(at: indexPaths)
        }
    }
    
    // 是否被修改
    public var dataHasChanged: Bool {
        guard let dataSource = dataSource else { return true }
        let sections = dataSource.numberOfSections?(in: self) ?? 0
        if numberOfSections != sections {
            return true
        }
        for section in 0 ..< sections {
            if numberOfItems(inSection: section) != dataSource.collectionView(self, numberOfItemsInSection: section) {
                return true
            }
        }
        return false
    }

    public func crs_reloadData() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        reloadData()
        CATransaction.commit()
    }

    func registerHeadView<T: UICollectionReusableView>(withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: name))
    }
    
    func registerHeadView<T: UICollectionReusableView>(withNib name: T.Type) {
        let nib = UINib(nibName: T.stringName(), bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: name))
    }

    func registerFooterView<T: UICollectionReusableView>(withNib name: T.Type) {
        let nib = UINib(nibName: T.stringName(), bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: name))
    }
    
    func registerFooterView<T: UICollectionReusableView>(withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: name))
    }

    func register<T: UICollectionViewCell>(withCellNib name: T.Type) {
        let nib = UINib(nibName: T.stringName(), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        let identifier = cellType.cellIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: identifier), for: indexPath) as? Cell else {
            fatalError(
                "\(identifier)), make sure the cell is registered")
        }
        return cell
    }

    func dequeueReusableSupplementaryViewFooter<T: UICollectionReusableView>(withClass name: T.Type, for indexPath: IndexPath) -> T
    {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: String(describing: name),
            for: indexPath
        ) as? T else {
            fatalError(
                "Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }

    func dequeueReusableSupplementaryViewHeader<T: UICollectionReusableView>(withClass name: T.Type, for indexPath: IndexPath) -> T
    {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: name),
            for: indexPath
        ) as? T else {
            fatalError(
                "Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }

    // 滚动到顶部
    func scrollToFirstItem(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        let lastItemIndexPath = IndexPath(item: 0, section: 0)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
    
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return }
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
}
