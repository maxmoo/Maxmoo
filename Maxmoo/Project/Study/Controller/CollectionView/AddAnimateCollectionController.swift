//
//  AddAnimateCollectionController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/30.
//

import UIKit
import SnapKit

class AddAnimateCollectionController: CCBaseViewController {

    var items: [String] = {
        var arr: [String] = []
        for i in 0...40 {
            arr.append("第\(i)个")
        }
        return arr
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.performBatchUpdates {
            
        }
//        collectionView.alwaysBounceVertical = true
//        collectionView.showsVerticalScrollIndicator = false
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
            make.top.left.right.bottom.equalToSuperview()
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
        items.insert("\(Int.random(in: 10...100))", at: 20)
        let addIndexPath = IndexPath(item: 20, section: 0)
        collectionView.insertItems(at: [addIndexPath])
    }
    
    @objc
    func deleteItem() {
        items.removeStart()
        collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
    }
}

extension AddAnimateCollectionController: UICollectionViewDelegate,
                                          UICollectionViewDataSource,
                                          UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .randomColor
        cell.removeAllSubviews()
        let item = items[indexPath.row]
        let label = UILabel(frame: cell.bounds)
        label.textAlignment = .center
        label.textColor = .randomColor
        label.text = item
        label.numberOfLines = 0
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectitonView select at: \(indexPath.row)")
    }
}
