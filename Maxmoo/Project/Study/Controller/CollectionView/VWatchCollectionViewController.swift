//
//  VWatchCollectionViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/29.
//

import UIKit
import SnapKit

class VWatchCollectionViewController: CCBaseViewController {

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
    }
}

extension VWatchCollectionViewController: UICollectionViewDelegate,
                                          UICollectionViewDataSource,
                                          UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .randomColor
        cell.removeAllSubviews()
        let label = UILabel(frame: cell.bounds)
        label.textAlignment = .center
        label.textColor = .randomColor
        label.text = "第\(indexPath.row)个"
        label.numberOfLines = 0
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectitonView select at: \(indexPath.row)")
    }
}


class CustomLayout: UICollectionViewFlowLayout {
    
    private var lastOffset: CGPoint = .zero
    
    override func prepare() {
        super.prepare()
        self.collectionView?.decelerationRate = .fast
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
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
        
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + minDelta)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visitRect = CGRect(x: (self.collectionView?.contentOffset.x)!,
                               y: (self.collectionView?.contentOffset.y)!,
                               width: (self.collectionView?.width)!,
                               height: (self.collectionView?.height)!)
        let arr = super.layoutAttributesForElements(in: visitRect)
        guard let arr = arr else { return nil }
        let centerY = (self.collectionView?.contentOffset.y)! + (self.collectionView?.height)! * 0.5
        let maxOffset = (self.collectionView?.height)! * 0.5
        let maxScale = 0.85
        let alphaScale = 0.5
        for item in arr where CGRectIntersectsRect(item.frame, visitRect) {
            let itemCenterY = item.center.y
            let offset = min(abs(itemCenterY - centerY), maxOffset)
            let scale = (1 - offset / maxOffset) * (1 - maxScale) + maxScale
            item.transform3D = CATransform3DMakeScale(scale, scale, 1.0)
            
            let a = (1 - offset / maxOffset) * (1 - alphaScale) + alphaScale
            item.alpha = a
        }
        
        return arr
    }
}
