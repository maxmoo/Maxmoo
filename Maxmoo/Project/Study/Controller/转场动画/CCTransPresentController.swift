//
//  CCTransPresentController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/17.
//

import UIKit

class CCTransPresentController: UIViewController {

    private var transitionDelegate: ExploreTransitionUtil? {
        return self.transitioningDelegate as? ExploreTransitionUtil
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        button.backgroundColor = .randomColor
        button.setTitle("back", for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "present"
        view.backgroundColor = .randomColor
        
        view.addSubview(backButton)
        
        let screenEdgePan = UIScreenEdgePanGestureRecognizer()
        screenEdgePan.edges = .left
        screenEdgePan.addTarget(self, action: #selector(screenEdgePanHandle(_:)))
        self.view.addGestureRecognizer(screenEdgePan)
    }

    ///边缘滑动dismiss
    @objc func screenEdgePanHandle(_ pan: UIScreenEdgePanGestureRecognizer) {
        guard let transitionDelegate else { return }
        let translationX = pan.translation(in: view).x
        let absX = abs(translationX)
        let progress = absX / view.frame.width
        
        switch pan.state {
        case .began:
            transitionDelegate.interactive = true
            self.dismiss(animated: true, completion: nil)
            
        case .changed:
            transitionDelegate.interactionTransition.update(progress)
            
        case .cancelled, .ended:
            if progress > 0.3 {
                transitionDelegate.interactionTransition.finish()
            }else {
                transitionDelegate.interactionTransition.cancel()
            }
            transitionDelegate.interactive = false
            
        default:
            transitionDelegate.interactive = false
        }
    }
    
    @objc
    func back() {
        dismiss(animated: true)
    }

}
