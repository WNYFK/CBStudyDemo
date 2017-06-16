//
//  CBOptionalSpeedViewController.swift
//  CBStudyDemo
//
//  Created by ChenBin on 2017/3/24.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

import Foundation

class CBOptionalSpeedViewController: CBBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let compilingSpeedSectionItem = CBSectionItem(title: "Optional Speed")
        self.dataArr.add(compilingSpeedSectionItem)
        
//        compilingSpeedSectionItem.cellItems.addObject(CBSkipItem(title: "speed: ??", callBack: { _ in
//            let tmp1: Int? = 1
//            let tmp2: Int? = 3
//            let tmp3: Int? = 4
//            let result: Int = (tmp1 ?? 0) + (tmp2 ?? 0) + (tmp3 ?? 0)
//            print(result)
//        }))
        
        compilingSpeedSectionItem?.cellItems.add(CBSkipItem(title: "speed: ?? 改后", callBack: { _ in
            let tmp1: Int? = 1
            let tmp2: Int? = 3
            let tmp3: Int? = 4
            let resultTmp1: Int = tmp1 ?? 0
            let resultTmp2: Int = tmp2 ?? 0
            let resultTmp3: Int = tmp3 ?? 0
            let result: Int = resultTmp1 + resultTmp2 + resultTmp3
            print(result)
        }))
    }
}
