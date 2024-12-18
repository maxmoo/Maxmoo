//
//  CRSDSThumbnailView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/12/17.
//

import UIKit
import SnapKit

protocol CRSDSThumbnailViewDelegate: NSObjectProtocol {
    func didSelect(index: Int)
}

class CRSDSThumbnailView: UIView {

    // 代理
    weak var delegate: CRSDSThumbnailViewDelegate?
    
    // 是否为手表
    public var isWatch: Bool = false
    
    // 显示区域大小
    public var contentSize: CGSize {
        if isWatch {
            return CGSize(width: 70, height: 70)
        } else {
            return CGSize(width: 70, height: 116)
        }
    }
    
    // 是否自动滚动（在滑动后）
    private var isAutoScroll: Bool = false
    
    private var isShouldDragRefresh: Bool = false
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        if isAutoScroll {
            layout = SnapToCenterFlowLayout()
        }
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .lightGray
        if isWatch, isAutoScroll {
            collectionView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 90, right: 0)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.reorderingCadence = .slow
        collectionView.isSpringLoaded = false
        collectionView.layer.masksToBounds = true
        collectionView.decelerationRate = .fast
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return collectionView
    }()
    
    struct ShowItem {
        var centerView: UIView?
        var title: String?
    }
    
    private var items: [CRSDSThumbnailContentView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    
    private func configData() {
        items.removeAll()

        for index in 0..<6 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
            label.backgroundColor = .randomColor
            label.textAlignment = .center
            if isWatch {
                label.layer.cornerRadius = contentSize.height / 2
            } else {
                label.layer.cornerRadius = 6
            }
            label.layer.masksToBounds = true
            
            let contentView = CRSDSThumbnailContentView(frame: CGRect(x: 0, y: 0, width: contentSize.width + 30, height: contentSize.height + 10), contentSize: contentSize, style: isWatch ? .watch : .dura)
            contentView.backgroundColor = .clear
            contentView.contentView.addSubview(label)
            
            items.append(contentView)
        }
        
        if items.count > 0, isAutoScroll {
            // first empty
            let firstEmptyContentView = CRSDSThumbnailContentView(frame: CGRect(x: 0, y: 0, width: contentSize.width + 30, height: contentSize.height + 10), contentSize: contentSize, style: isWatch ? .watch : .dura, type: .empty)
            items.insert(firstEmptyContentView, at: 0)
            
            // last empty
            let lastEmptyContentView = CRSDSThumbnailContentView(frame: CGRect(x: 0, y: 0, width: contentSize.width + 30, height: contentSize.height + 10), contentSize: contentSize, style: isWatch ? .watch : .dura, type: .empty)
            items.append(lastEmptyContentView)
        }
        
        refreshItemsIndex()
        collectionView.reloadData()
    }
    
    // 移动到选中的位置
    func scrollToSelectedIndex() {
        var scrollIndex: Int?
        for (ind, item) in items.enumerated() {
            if item.isSelect {
                scrollIndex = ind
                break
            }
        }
        
        if let scrollIndex {
            let selectIndexPath = IndexPath(row: scrollIndex, section: 0)
            collectionView.scrollToItem(at: selectIndexPath, at: .centeredVertically, animated: true)
        }
    }
    
    // 交换两个item
    func swapItems(at firstIndex: Int, with secondIndex: Int, animate: Bool = true) {
        guard firstIndex > 0, firstIndex < items.count,
              secondIndex > 0 , secondIndex < items.count else { return }
        
        let firstIndexPath = IndexPath(row: firstIndex, section: 0)
        let secondIndexPath = IndexPath(row: secondIndex, section: 0)

        // 更新数据源
        let tmp = items[firstIndexPath.item]
        items[firstIndexPath.item] = items[secondIndexPath.item]
        items[secondIndexPath.item] = tmp

        if animate {
            // 执行交换动画
            collectionView.performBatchUpdates({
                collectionView.moveItem(at: firstIndexPath, to: secondIndexPath)
                collectionView.moveItem(at: secondIndexPath, to: firstIndexPath)
            }) { [weak self] success in
                guard let self else { return }
                if success, self.isAutoScroll {
                    self.scrollToSelectedIndex()
                }
            }
        } else {
            collectionView.reloadData()
            if isAutoScroll {
                scrollToSelectedIndex()
            }
        }
    }

    // 选中某一个item
    func selectIndex(index: Int) {
        guard index >= 0 && index < items.count else { return }
        
        var selectIndex: Int = index
        if isAutoScroll {
            if index == 0 {
                selectIndex = 1
            } else if index == items.count - 1 {
                selectIndex = items.count - 2
            }
        }
        
        for (ind, item) in items.enumerated() {
            item.isSelect = ind == selectIndex
        }
        
        let selectIndexPath = IndexPath(row: selectIndex, section: 0)
        collectionView.scrollToItem(at: selectIndexPath, at: .centeredVertically, animated: true)
    }
    
    // 选中中间的item
    func selectCenterItem() {
        if let centerIndexPath = currentCenterIndexPath() {
            selectIndex(index: centerIndexPath.row)
            if isAutoScroll, let delegate {
                delegate.didSelect(index: centerIndexPath.row)
            }
        }
    }
    
    // 当前中央的index
    private func currentCenterIndexPath() -> IndexPath? {
        // 计算 collectionView 的可视区域的中心点
        let centerPoint = CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height / 2 + collectionView.contentOffset.y)
        // 获取此点的 indexPath
        return collectionView.indexPathForItem(at: centerPoint)
    }
    
    // 在当前中央插入一条数据
    func insertItemAtCurrentCenter() {
        let firstEmptyContentView = CRSDSThumbnailContentView(frame: CGRect(x: 0, y: 0, width: contentSize.width + 30, height: contentSize.height + 10), contentSize: contentSize, style: isWatch ? .watch : .dura, type: .add)
        firstEmptyContentView.isSelect = true
        
        var centerIndexPath = IndexPath(row: 0, section: 0)
        if let currentCenterIndexPath = currentCenterIndexPath() {
            centerIndexPath = currentCenterIndexPath
            items.forEach { $0.isSelect = false }
        }
        
        items.insert(firstEmptyContentView, at: centerIndexPath.row)
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.insertItems(at: [centerIndexPath])
        }, completion: { [weak self] finished in
            self?.collectionView.scrollToItem(at: centerIndexPath, at: .centeredVertically, animated: true)
            self?.refreshItemsIndex()
        })
    }
    
    // 移除当前显示在正中间的item
    func removeItemAtCurrentCenter() {
        if let centerIndexPath = currentCenterIndexPath() {
            removeItemAtIndex(centerIndexPath.row)
        }
    }
    
    // 移除某一个index的item
    func removeItemAtIndex(_ removeIndex: Int) {
        guard removeIndex >= 0, removeIndex < items.count else { return }
        
        items.remove(at: removeIndex)
        let removeIndexPath = IndexPath(row: removeIndex, section: 0)
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.deleteItems(at: [removeIndexPath])
        }) { [weak self] success in
            if success {
                self?.refreshItemsIndex()
            }
        }
    }
    
    // 刷新索引值
    func refreshItemsIndex() {
        for (ind, item) in items.enumerated() {
            if !isAutoScroll {
                item.index = ind + 1
            } else {
                item.index = ind
            }
        }
    }
}

extension CRSDSThumbnailView: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentSize.width + 30, height: contentSize.height + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.removeAllSubviews()
        cell.backgroundColor = .lightGray
        cell.contentView.backgroundColor = .lightGray
        
        let item = items[indexPath.row]
        cell.addSubview(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.type != .empty {
            for (ind, it) in items.enumerated() {
                it.isSelect = indexPath.row == ind
            }
            
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            if let delegate {
                delegate.didSelect(index: indexPath.row)
            }
        }
    }

}

extension CRSDSThumbnailView {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isAutoScroll {
            selectCenterItem()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
}

//MARK: -- 拖拽代理
extension CRSDSThumbnailView: UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    // 识别到拖动，是否响应
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = items[indexPath.row]
        if item.type == .empty {
            return []
        } else {
            let itemData = "\(indexPath.section)_\(indexPath.row)"
            let itemProvider = NSItemProvider(object: itemData as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = itemData
            return [dragItem]
        }
    }
    
    /*
    // 开始拖拽后，继续添加拖拽的任务，这里就不需要了，处理同`itemsForBeginning`方法
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {

    }
     */
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        // 拖拽开始，可自行处理
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        // 拖拽结束，可自行处理
    }
    
    // 除去拖拽时候的阴影
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 30, y: 5, width: contentSize.width, height: contentSize.height))
        previewParameters.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            previewParameters.shadowPath = UIBezierPath(rect: .zero)
        }
        return previewParameters
    }
    
    // 是否能放置
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    // 处理拖动中放置的策略
    // 四种分别：move移动；copy拷贝；forbidden禁止，即不能放置；cancel用户取消。
    // 效果一般使用2种：.insertAtDestinationIndexPath 挤压移动；.insertIntoDestinationIndexPath 取代。
    // 一般的用挤压的多
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let destinationIndexPath {
            let item = items[destinationIndexPath.row]
            if item.type == .empty {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        if session.localDragSession != nil {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    // 结束放置时的处理
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        switch coordinator.proposal.operation {
        case .move:
            UIView.setAnimationsEnabled(false)

            let items = coordinator.items
            if let item = items.first,let sourceIndexPath = item.sourceIndexPath {
                if sourceIndexPath.row != destinationIndexPath.row {
                    // 执行批量更新
                    collectionView.performBatchUpdates { [weak self] in
                        if let obj = self?.items.remove(at: sourceIndexPath.row) {
                            self?.items.insert(obj, at: destinationIndexPath.row)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                        }
                    }
                    
                    isShouldDragRefresh = true
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
            
            refreshItemsIndex()
            if isAutoScroll {
                scrollToSelectedIndex()
            }
            
            break
        case .copy:
            break
        default:
            return
        }
    }
    
    // 当dropSession 完成时会被调用，不管结果如何。一般进行清理或刷新操作
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if isShouldDragRefresh {
            collectionView.reloadSections(IndexSet(integer: 0))
            isShouldDragRefresh = false
        }
        UIView.setAnimationsEnabled(true)
    }
    
    // 当drop会话进入到 collectionView 的坐标区域内就会调用
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
    }
    
    // 当 dropSession 不在collectionView 目标区域的时候会被调用
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {

    }
   
    // 同属性 isSpringLoaded
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        true
    }
    
}


class SnapToCenterFlowLayout: UICollectionViewFlowLayout {
    
    // 此方法返回 collection view 停止滚动后最终的位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        // 计算中心位置
        let midY = collectionView.bounds.size.height / 2
        let proposedMidY = proposedContentOffset.y + midY

        // 获取布局属性的当前可见区域
        let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        // 确定离中心点最近的 item
        var closestAttribute: UICollectionViewLayoutAttributes?
        for layoutAttributes in layoutAttributesArray {
            if closestAttribute == nil {
                closestAttribute = layoutAttributes
                continue
            }
            let attributesMidY = layoutAttributes.center.y
            let closestMidY = closestAttribute!.center.y
            if abs(attributesMidY - proposedMidY) < abs(closestMidY - proposedMidY) {
                closestAttribute = layoutAttributes
            }
        }

        // 根据最近的 item 调整 proposedContentOffset
        if let closestAttribute = closestAttribute {
            let centerOffsetY = closestAttribute.center.y - midY
            let targetY = centerOffsetY - (self.sectionInset.top - self.sectionInset.bottom) / 2
            return CGPoint(x: proposedContentOffset.x, y: targetY)
        }

        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}

