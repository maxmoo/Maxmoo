//
//  CRSClimbListItem.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import UIKit

struct CRSClimbListItem {
    var isExtra: Bool
    var infos: [CRSTrackClimbInfo]
    var startIndex: Int
    var endIndex: Int
    
    var lapString: String?
    var distanceString: String?
    var distanceScopeString: String?
    var percentageString: String?
    var climbValueString: String?
    
    init(isExtra: Bool, infos: [CRSTrackClimbInfo], startIndex: Int, endIndex: Int) {
        self.isExtra = isExtra
        self.infos = infos
        self.startIndex = startIndex
        self.endIndex = endIndex
        
        self.lapString = "1/4"
        self.distanceString = "2.352km"
        self.distanceScopeString = "2.34-2.56km"
        self.percentageString = "50%"
        self.climbValueString = "2000m"
    }
}
