//
//  PageGuideViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

class PageGuideViewController: CCBaseViewController {
    
    enum PageStep {
        case pre
        case next
    }
    
    private lazy var pageController: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return page
    }()
    
    private lazy var preButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("上一个", for: .normal)
        button.addTarget(self, action: #selector(preAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("下一个", for: .normal)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()
    
    private var childControllers: [UIViewController] = {
       return [PageGuide1ViewController(),
               PageGuide2ViewController(),
               PageGuide3ViewController()]
    }()
    
    private var currentController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setCurrentController(childControllers.first)
    }

    func setupUI() {
        addChild(pageController)
        view.addSubview(pageController.view)
        view.addSubview(preButton)
        preButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(100)
            make.width.height.equalTo(60)
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(100)
            make.width.height.equalTo(60)
        }
    }
    
    @objc
    func preAction() {
        if let currentIndex = index(of: currentController),
           let preC = controller(index: currentIndex - 1) {
            setCurrentController(preC, animateStyle: .pre)
        }
    }
    
    @objc
    func nextAction() {
        if let currentIndex = index(of: currentController),
           let nextC = controller(index: currentIndex + 1) {
            setCurrentController(nextC, animateStyle: .next)
        }
    }
    
    func index(of controller: UIViewController?) -> Int? {
        guard let controller = controller else { return nil }
        for (index, c) in childControllers.enumerated() where c == controller {
           return index
        }
        return nil
    }
    
    func controller(index: Int) -> UIViewController? {
        guard index >= 0 && index < childControllers.count else { return nil }
        return childControllers[index]
    }
    
    func setCurrentController(_ controller: UIViewController?, animateStyle: PageStep? = nil) {
        guard let controller = controller else { return }
        var direction: UIPageViewController.NavigationDirection = .reverse
        if let animateStyle = animateStyle {
            switch animateStyle {
            case .pre:
                direction = .reverse
            case .next:
                direction = .forward
            }
        }
        pageController.setViewControllers([controller],
                                direction: direction,
                                animated: true) { [weak self] result in
            guard let self = self else {return}
            self.currentController = controller
        }
    }
}
