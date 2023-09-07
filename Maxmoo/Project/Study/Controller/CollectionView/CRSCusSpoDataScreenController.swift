//
//  CRSCusSpoDataScreenController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/7.
//

import UIKit

class CRSCusSpoDataScreenController: UIViewController {

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
    
    lazy var itemView: CRSCusSpoPageView<UIView> = {

        let view = CRSCusSpoPageView(frame: CGRect(x: 0, y: 150, width: 250, height: 300),
                                     shadowInsets: UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0),
                                     direction: .vertical)
        view.backgroundColor = .red
        view.currentItemChanged = {
            index in
            print("vertical: \(index)")
        }
        view.items = [createView(info: "0"),
                      createView(info: "1"),
                      createView(info: "2"),
                      createView(info: "3"),
                      createView(info: "4")]
        return view
    }()
    
    lazy var hItemView: CRSCusSpoPageView<UIView> = {

        let view = CRSCusSpoPageView(frame: CGRect(x: 0, y: 500, width: 300, height: 250),
                                     shadowInsets: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25),
                                     direction: .horizontal)
        view.backgroundColor = .red
        view.currentItemChanged = {
            index in
            print("horizontal: \(index)")
        }
        view.items = [createView(info: "0"),
                      createView(info: "1"),
                      createView(info: "2"),
                      createView(info: "3"),
                      createView(info: "4")]
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(120)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(120)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(itemView)
        itemView.centerX = view.width/2
        
        view.addSubview(hItemView)
        hItemView.centerX = view.width/2
    }

    func createView(info: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        view.backgroundColor = .randomColor
        
        let label = UILabel(frame: view.bounds)
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.text = info
        view.addSubview(label)
        
        return view
    }
    
    @objc
    func addItem() {
        itemView.currentInsert(item: createView(info: "\(Int.random(in: 10...100))"), animate: true)
        hItemView.currentInsert(item: createView(info: "\(Int.random(in: 10...100))"), animate: true)
    }
    
    @objc
    func deleteItem() {
        itemView.currentDelete(animate: true) { _ in
            print("delete complete")
        }
        hItemView.currentDelete(animate: true) { _ in
            print("delete complete")
        }
    }
}
