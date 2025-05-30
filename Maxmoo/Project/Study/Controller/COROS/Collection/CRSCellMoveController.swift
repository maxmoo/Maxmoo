//
//  CRSCellMoveController.swift
//  Maxmoo
//
//  Created by 程超 on 2025/5/23.
//

import UIKit

class CRSCellMoveController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenWidth, height: 48)
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 30)
        layout.footerReferenceSize = CGSize(width: kScreenWidth, height: 80)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.dataSource = self
        collection.delegate = self
        collection.dragDelegate = self
        collection.dropDelegate = self
        collection.dragInteractionEnabled = true
        
        collection.register(withCellNib: CRSMoveCollectionViewCell.self)
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        return collection
    }()
    
    // 数据源，两个section，每个section一个数组
    private var sectionData: [[String]] = [
        ["A1", "A2", "A3", "A4"],
        ["B1", "B2", "B3", "B4"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension CRSCellMoveController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout {
        
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: CRSMoveCollectionViewCell.self, for: indexPath)
        cell.isAdd = indexPath.section == 0
        cell.rightAction = { [weak self] isAdd in
            if isAdd {
                self?.deleteItem(indexPath)
            } else {
                self?.addItem(indexPath)
            }
        }
        
        // 区分每个section的第一个cell、最后一个cell以及其余的cell
        if indexPath.row == 0 {
            cell.backgroundColor = .red // 第一个cell
        } else if indexPath.row == sectionData[indexPath.section].count - 1 {
            cell.backgroundColor = .blue // 最后一个cell
        } else {
            cell.backgroundColor = .green // 其余的cell
        }
        
        return cell
    }
    
    @objc private func deleteItem(_ indexPath: IndexPath) {
        let item = sectionData[indexPath.section][indexPath.row]
        
        // 从section=0中移除
        sectionData[0].remove(at: indexPath.row)
        
        // 添加到section=1的第一个位置
        sectionData[1].insert(item, at: 0)
        
        // 更新UI
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
            collectionView.insertItems(at: [IndexPath(item: 0, section: 1)])
        }, completion: nil)
    }
    
    @objc private func addItem(_ indexPath: IndexPath) {
        let item = sectionData[indexPath.section][indexPath.row]
        
        // 从section=1中移除
        sectionData[1].remove(at: indexPath.row)
        
        // 添加到section=0的最后一个位置
        sectionData[0].append(item)
        
        // 更新UI
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
            collectionView.insertItems(at: [IndexPath(item: sectionData[0].count - 1, section: 0)])
        }, completion: nil)
    }
    
    // MARK: - Section Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            header.backgroundColor = .clear
            // 移除旧label
            header.subviews.forEach { $0.removeFromSuperview() }
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: collectionView.bounds.width-32, height: 30))
            label.text = "Section \(indexPath.section + 1)"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = .lightGray
            header.addSubview(label)
            return header
        }
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            footer.backgroundColor = .clear
            // 移除旧label
            footer.subviews.forEach { $0.removeFromSuperview() }
            if indexPath.section == 1 {
                let footerBackView = UIView(frame: CGRect(x: 16, y: 16, width: kScreenWidth - 32, height: 48))
                footerBackView.layer.cornerRadius = 12
                footerBackView.layer.masksToBounds = true
                footerBackView.backgroundColor = .white
                
                let label = UILabel(frame: CGRect(x: 16, y: 0, width: footerBackView.width - 32, height: 24))
                label.centerY = footerBackView.height / 2
                label.text = "Footer for Section 2"
                label.font = UIFont.boldSystemFont(ofSize: 15)
                label.textColor = .blue
                footerBackView.addSubview(label)
                
                footer.addSubview(footerBackView)
            }
            return footer
        }
        return UICollectionReusableView()
    }
    
    // MARK: - UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section != 0 {
            return []
        }
        let item = sectionData[indexPath.section][indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = (indexPath, item)
        return [dragItem]
    }
    
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        for item in coordinator.items {
            if let source = item.dragItem.localObject as? (IndexPath, String) {
                collectionView.performBatchUpdates({
                    // 删除原位置
                    sectionData[source.0.section].remove(at: source.0.item)
                    // 插入新位置
                    sectionData[destinationIndexPath.section].insert(source.1, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [source.0])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: nil)
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            if let destinationIndexPath = destinationIndexPath, destinationIndexPath.section == 0 {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 20)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 64)
        }
    }
}
