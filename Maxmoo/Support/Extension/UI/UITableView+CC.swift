//
//  UITableView+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import Foundation

extension UITableView {
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1
            )
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }

    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }

    func register<T: UITableViewCell>(withCellNib name: T.Type) {
        let nib = UINib(nibName: T.stringName(), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<Cell: UITableViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        let identifier = cellType.cellIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            assertionFailure(
                "Couldn't find UITableViewCell for \(identifier)), make sure the cell is registered with table view")
            let cell = register(cellWithClass: UITableViewCell.self)
            return Cell()
        }
        return cell
    }
}


extension NSObject {
    static func stringName() -> String {
        String(describing: self)
    }
}

extension UITableViewCell {
    static var cellIdentifier: String {
        typeName
    }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

    static var typeName: String {
        return String(describing: self)
    }

    var typeName: String {
        return String(describing: self.self)
    }
}
