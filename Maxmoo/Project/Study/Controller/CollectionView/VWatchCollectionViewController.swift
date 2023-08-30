//
//  VWatchCollectionViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/29.
//

import UIKit
import SnapKit

class VWatchCollectionViewController: CCBaseViewController {

    let yOffset: CGFloat = 10
    
    var items: [String] = {
        return ["1", "2", "3", "4", "5", "6"]
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = CustomLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(120)
            make.height.equalTo(400)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(120)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(120)
            make.width.height.equalTo(100)
        }
    }
    
    @objc
    func addItem() {
        var addIndex: Int = 0
        if let index = currentCenterIndex() {
            addIndex = index
        }
        items.insert("\(Int.random(in: 10...100))", at: addIndex)
        let addIndexPath = IndexPath(item: addIndex, section: 0)
        collectionView.insertItems(at: [addIndexPath])
    }
    
    @objc
    func deleteItem() {
        items.removeStart()
        collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    private func currentCenterIndex() -> Int? {
        let offsetY = collectionView.contentOffset.y
        let index = (offsetY + 10 + yOffset) / 210
        return Int(index + 0.5)
    }
}

extension VWatchCollectionViewController: UICollectionViewDelegate,
                                          UICollectionViewDataSource,
                                          UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .randomColor
        cell.removeAllSubviews()
        let item = items[indexPath.row]
        let label = UILabel(frame: cell.bounds)
        label.textAlignment = .center
        label.textColor = .randomColor
        label.text = "第\(item)个"
        label.numberOfLines = 0
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectitonView select at: \(indexPath.row)")
    }
}


class CustomLayout: UICollectionViewFlowLayout {
    
    private var updateItems: [UICollectionViewUpdateItem] = []
    
    override func prepare() {
        super.prepare()
        self.collectionView?.decelerationRate = .fast
    }
    
    // 是否重新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // 最终停在的位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
 
        let visitRect = CGRect(x: proposedContentOffset.x,
                               y: proposedContentOffset.y,
                               width: self.collectionView?.width ?? 200,
                               height: self.collectionView?.height ?? 400)
        let arr = super.layoutAttributesForElements(in: visitRect)
        guard let arr = arr else { return CGPoint.zero }
        
        let centerY = proposedContentOffset.y + (self.collectionView?.height ?? 400) * 0.5
        var minDelta:CGFloat = CGFloat(MAXFLOAT)
        for item in arr {
            let de = item.center.y - centerY
            if abs(minDelta) > abs(de) {
                minDelta = de
            }
        }
        
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + minDelta - 10)
    }
    
    // 增加滑动时的动画
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let visitRect = CGRect(x: (self.collectionView?.contentOffset.x)!,
//                               y: (self.collectionView?.contentOffset.y)!,
//                               width: (self.collectionView?.width)!,
//                               height: (self.collectionView?.height)!)
//        let arr = super.layoutAttributesForElements(in: visitRect)
//        guard let arr = arr else { return nil }
//        let centerY = (self.collectionView?.contentOffset.y)! + (self.collectionView?.height)! * 0.5
//        let maxOffset = (self.collectionView?.height)! * 0.5
//        let maxScale = 0.85
//        let alphaScale = 0.5
//        for item in arr where CGRectIntersectsRect(item.frame, visitRect) {
//            let itemCenterY = item.center.y
//            let offset = min(abs(itemCenterY - centerY), maxOffset)
//            let scale = (1 - offset / maxOffset) * (1 - maxScale) + maxScale
//            item.transform3D = CATransform3DMakeScale(scale, scale, 1.0)
//
//            let a = (1 - offset / maxOffset) * (1 - alphaScale) + alphaScale
//            item.alpha = a
//        }
//
//        return arr
//    }
    
    // 动画时cell的起始状态
//    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attr = self.layoutAttributesForItem(at: itemIndexPath)
//        for updateItem in updateItems {
//            switch updateItem.updateAction {
//            case .delete:
//                break
//            case .insert:
//                guard updateItem.indexPathAfterUpdate == itemIndexPath else { break }
//                attr?.center = CGPoint(x: CGRectGetMaxX(self.collectionView!.bounds),
//                                       y: CGRectGetMidY(self.collectionView!.bounds))
//                attr?.alpha = 0
//            case .move:
//                break
//            default:
//                break
//            }
//        }
//
////        attr?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), Double.pi)
//        return attr
//    }
//    
//    // 动画cell的终点状态
//    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attr = self.layoutAttributesForItem(at: itemIndexPath)
//        for updateItem in updateItems {
//            switch updateItem.updateAction {
//            case .delete:
//                guard updateItem.indexPathBeforeUpdate == itemIndexPath else { break }
//                attr?.center = CGPoint(x: 0,
//                                       y: CGRectGetMidY(self.collectionView!.bounds))
//                attr?.alpha = 0
//            case .insert:
//                attr?.alpha = 1
//               break
//            case .move:
//                break
//            default:
//                break
//            }
//        }
//        return attr
//    }
//    
//    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
//        super.prepare(forCollectionViewUpdates: updateItems)
//        self.updateItems = updateItems
//    }
}
