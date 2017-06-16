//
//  CBArraySpeedViewController.swift
//  CBStudyDemo
//
//  Created by ChenBin on 2017/3/24.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

import Foundation

class CBArraySpeedViewController: CBBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sectionItem = CBSectionItem(title: "Array 性能")
        self.dataArr.add(sectionItem)
        
//        sectionItem.cellItems.addObject(CBSkipItem(title: "Array + Array", callBack: { _ in
//            let arr1 = ["1"]
//            let arr2 = ["2"]
//            let arr3 = ["3"]
//            let result = arr1 + arr2 + arr3
//            print(result)
//        }))
        
//        sectionItem.cellItems.addObject(CBSkipItem(title: "Array + Array 改后", callBack: { _ in
//            let arr1 = ["1"]
//            let arr2 = ["2"]
//            let arr3 = ["3"]
//            var result = arr1
//            result.appendContentsOf(arr2)
//            result.appendContentsOf(arr3)
//            print(result)
//        }))
//        
//        sectionItem.cellItems.addObject(CBSkipItem(title: "Array + Array 改后", callBack: { _ in
//            let week: [String] = ["", "日", "一", "二", "三", "四", "五", "六"]
//            print(week[1])
//        }))
        
//        sectionItem.cellItems.addObject(CBSkipItem(title: "Array + Array 改后", callBack: { _ in
//            print("\(["", "日", "一", "二", "三", "四", "五", "六"][1])")
//        }))
        
        sectionItem?.cellItems.add(CBSkipItem(title: "Array + Array 改后", callBack: { _ in
            let week: [Int] = [1, 2, 5, 7, 6]
            var week2: [Int] = [1, 3, 4, 5, 7]
            week2.append(contentsOf: [])
            if week == week2 {
                print("")
            }
        }))
    }
}
