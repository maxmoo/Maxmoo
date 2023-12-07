//
//  CRSCastScreenDataStyle.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/7.
//

import UIKit

enum CRSCastScreenDataStyle {
    case none
    case one
    case two
    case three
    case four
    case six
    case eight
    case ten
    
    static func style(count: Int) -> CRSCastScreenDataStyle {
        switch count {
        case let x where x < 0:
            return .none
        case 1:
            return .one
        case 2:
            return .two
        case 3:
            return .three
        case 4:
            return .four
        case 5, 6:
            return .six
        case 7, 8:
            return .eight
        case let x where x > 8:
            return .ten
        default:
            return .none
        }
    }
    
    // MARK: - font
    var titleFont: UIFont {
        switch self {
        case .one, .two:
            return UIFont.systemFont(ofSize: 32, weight: .medium)
        case .three:
            return UIFont.systemFont(ofSize: 28, weight: .medium)
        case .four:
            return UIFont.systemFont(ofSize: 24, weight: .medium)
        case .six, .eight, .ten, .none:
            return UIFont.systemFont(ofSize: 18, weight: .medium)
        }
    }
    
    var valueFont: UIFont {
        switch self {
        case .one, .two:
            return UIFont.systemFont(ofSize: 100, weight: .bold)
        case .three:
            return UIFont.systemFont(ofSize: 88, weight: .bold)
        case .four:
            return UIFont.systemFont(ofSize: 74, weight: .bold)
        case .six, .eight, .ten, .none:
            return UIFont.systemFont(ofSize: 52, weight: .bold)
        }
    }
    
    var unitFont: UIFont {
        switch self {
        case .one, .two:
            return UIFont.systemFont(ofSize: 40, weight: .bold)
        case .three:
            return UIFont.systemFont(ofSize: 32, weight: .bold)
        case .four:
            return UIFont.systemFont(ofSize: 28, weight: .bold)
        case .six, .eight, .ten, .none:
            return UIFont.systemFont(ofSize: 20, weight: .bold)
        }
    }
    
    // MARK: - yOffset
    var valueOffset: CGFloat {
        switch self {
        case .one:
            return 20
        case .two:
            return 20
        case .three:
            return 20
        case .four:
            return 15
        case .six:
            return 12
        case .eight:
            return 10
        case .ten, .none:
            return 10
        }
    }
    
    var unitOffset: CGFloat {
        switch self {
        case .one:
            return 20
        case .two:
            return 20
        case .three:
            return 18
        case .four:
            return 15
        default:
            return 10
        }
    }
    
    var titleOffset: CGFloat {
        switch self {
        case .one:
            return -70
        case .two:
            return -50
        case .three:
            return -40
        case .four:
            return -35
        case .six:
            return -30
        case .eight, .ten, .none:
            return -25
        }
    }
    
    // MARK: - size
    func itemSize(in controller: UIViewController) -> CGSize {
        let contentHeight: CGFloat = kScreenHeight - kNavigationAndStatuBarHeight - controller.view.safeAreaInsets.bottom - contentEdge.top - contentEdge.bottom
        let hGapSet = self.hCount > 1 ? (hGap * CGFloat(self.hCount - 1)) : 0
        let itemWidth = (kScreenWidth - (contentEdge.left + contentEdge.right) - hGapSet)/CGFloat(self.hCount)
        let vGapSet = self.vCount > 1 ? (vGap * CGFloat(self.vCount - 1)) : 0
        let itemHeight = (contentHeight - vGapSet)/CGFloat(self.vCount)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // MARK: - edge
    var contentEdge: UIEdgeInsets {
        switch self {
        default:
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
    
    // MARK: - gap
    var hGap: CGFloat {
        switch self {
        default:
            return 16
        }
    }
    
    var vGap: CGFloat {
        switch self {
        default:
            return 16
        }
    }
    
    // MARK: - count
    var hCount: Int {
        switch self {
        case .one, .two, .three, .four:
            return 1
        case .six, .eight, .ten:
            return 2
        case .none:
            return 1
        }
    }
    
    var vCount: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .six:
            return 3
        case .eight:
            return 4
        case .ten:
            return 5
        case .none:
            return 1
        }
    }
    
    // MARK: - test
    var testCount: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .six:
            return 5
        case .eight:
            return 7
        case .ten:
            return 9
        case .none:
            return 0
        }
    }
    
    var testName: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .six:
            return "6"
        case .eight:
            return "8"
        case .ten:
            return "10"
        case .none:
            return "0"
        }
    }
}
