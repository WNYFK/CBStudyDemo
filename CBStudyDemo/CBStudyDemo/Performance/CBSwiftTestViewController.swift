//
//  CBSwiftTestViewController.swift
//  CBStudyDemo
//
//  Created by ChenBin on 2017/3/24.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

import Foundation

class CBSwiftTestViewController: CBBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let compilingSpeedSectionItem = CBSectionItem(title: "swift compiling speed")
        self.dataArr.add(compilingSpeedSectionItem)
        
        compilingSpeedSectionItem?.cellItems.add(CBSkipItem(title: "Optional Speed", destinationClass: CBOptionalSpeedViewController.self as AnyClass))
        compilingSpeedSectionItem?.cellItems.add(CBSkipItem(title: "Array Speed", destinationClass: CBArraySpeedViewController.self as AnyClass))
    }
}
