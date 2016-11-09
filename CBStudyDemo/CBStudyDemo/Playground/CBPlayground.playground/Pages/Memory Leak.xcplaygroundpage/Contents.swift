//: [Previous](@previous)

import Foundation

//: closure里调用局部函数，局部函数有对self相关进行操作，会内存泄漏

class CBTest {
    var name: String = ""
    var closure: (() -> Void)?
    deinit {
        print("deinit")
    }
    
    func startTest() {
        func handle() {
            print("handle")
            print(self)
        }
        self.closure = { _ in
            print("closure start")
            handle()
        }
        self.closure?()
    }
}

CBTest().startTest()

//: 解决方法1、weak self

class CBTestReust {
    var name: String = ""
    var closure: (() -> Void)?
    deinit {
        print("deinit")
    }
    
    func startTest() {
        weak var `self` = self
        func handle() {
            print("handle")
            print(self)
        }
        self?.closure = { _ in
            print("closure start")
            handle()
        }
        self?.closure?()
    }
}

CBTestReust().startTest()
//: [Next](@next)
