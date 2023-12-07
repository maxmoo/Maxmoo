//
//  DataCollectController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/1.
//

import UIKit
import SnapKit

class CRSCastScreenDataController: UIViewController {

    var dataShowType: CRSCastScreenDataStyle = .six {
        didSet {
            collectionView.reloadData()
        }
    }
    
    struct ShowItem {
        var title: String
        var value: String
        var unit: String?
    }
    
    var items: [ShowItem] = []
    
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        flowLayout.minimumLineSpacing = dataShowType.vGap
        flowLayout.minimumInteritemSpacing = dataShowType.hGap
        
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: kScreenWidth,
                                                            height: 0),
                                              collectionViewLayout: flowLayout)
        collectionView.contentInset = dataShowType.contentEdge
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "CRSCastScreenDataCell", bundle: nil), forCellWithReuseIdentifier: "CRSCastScreenDataCell")
        return collectionView
    }()
        
    lazy var testAction: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("action", for: .normal)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(pushSort), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
        setupUI()
    }

    private func configData() {
        items.removeAll()
        for index in 0..<dataShowType.testCount {
            let item = ShowItem(title: "距离\(index)", value: "5:05", unit: "cm")
            items.append(item)
        }
        collectionView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview()
        }
        
        view.addSubview(testAction)
        testAction.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.height.equalTo(60)
            make.bottom.equalTo(-100)
        }
    }
    
    @objc
    private func pushSort() {
        let sortVC = CRSCastScreenDataSettingController()
        sortVC.completeBlock = {
            [weak self] saveStyle in
            self?.dataShowType = saveStyle
        }
        navigationController?.pushViewController(sortVC, animated: true)
    }

}

extension CRSCastScreenDataController: UICollectionViewDelegate,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataShowType.itemSize(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CRSCastScreenDataCell", for: indexPath) as! CRSCastScreenDataCell
        let item = items[indexPath.row]
        
        cell.dataStyle = dataShowType
        
        cell.titleLabel.text = item.title
        cell.valueLabel.text = item.value
        cell.unitLabel.text = item.unit
        
        cell.backgroundColor = .randomColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
