//
//  ImageStudyController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/15.
//

import UIKit

class ImageStudyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        view.backgroundColor = .red
        
        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.image = view.image()?.png()
        self.view.addSubview(imageView)
    }

}
