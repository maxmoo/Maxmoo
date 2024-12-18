//
//  CRSCollectionDragCellController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/12/17.
//

import UIKit
import SnapKit

class CRSCollectionDragCellController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        let th = CRSDSThumbnailView(frame: .zero)
        th.backgroundColor = .clear
        th.delegate = self
        view.addSubview(th)
        th.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(350)
        }
        
        let leftLabel = UILabel(frame: .zero)
        leftLabel.text = "exchange"
        leftLabel.backgroundColor = .randomColor
        view.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.top.equalTo(120)
            make.height.width.equalTo(60)
        }
        leftLabel.addTapGesture {
            th.swapItems(at: 2, with: 5)
        }
        
        let insertLabel = UILabel(frame: .zero)
        insertLabel.text = "insert"
        insertLabel.backgroundColor = .randomColor
        view.addSubview(insertLabel)
        insertLabel.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.top.equalTo(200)
            make.height.width.equalTo(60)
        }
        insertLabel.addTapGesture {
            th.insertItemAtCurrentCenter()
        }
        
        let rightLabel = UILabel(frame: .zero)
        rightLabel.text = "random select"
        rightLabel.backgroundColor = .randomColor
        view.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.left.equalTo(kScreenWidth - 100)
            make.top.equalTo(120)
            make.height.width.equalTo(60)
        }
        rightLabel.addTapGesture {
            th.selectIndex(index: Int.random(in: 0..<6))
        }
        
        let removeLabel = UILabel(frame: .zero)
        removeLabel.text = "remove"
        removeLabel.backgroundColor = .randomColor
        view.addSubview(removeLabel)
        removeLabel.snp.makeConstraints { make in
            make.left.equalTo(kScreenWidth - 100)
            make.top.equalTo(200)
            make.height.width.equalTo(60)
        }
        removeLabel.addTapGesture {
            th.removeItemAtCurrentCenter()
        }
    }
    
}

extension CRSCollectionDragCellController: CRSDSThumbnailViewDelegate {
    
    func didSelect(index: Int) {
        print("did select at index: \(index)")
    }

}
