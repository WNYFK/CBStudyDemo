//: [Previous](@previous)
import Foundation
//: 一、 Protocol 泛型

//: 1、associatedtype
protocol CBReloadDataProtocol {
    associatedtype AbstractType
    func reloadData(object: AbstractType?, error: NSError?)
}

struct CBReloadDataProtocolThunk<T>: CBReloadDataProtocol {
    let reloadDataClosure: (T?, NSError?) -> Void
    let goalObj: Any
    
    func reloadData(object: T?, error: NSError?) {
        self.reloadDataClosure(object, error)
    }
    
    init<U: CBReloadDataProtocol>(_ reloadProtocol: U) where U.AbstractType == T {
        self.reloadDataClosure = reloadProtocol.reloadData
        self.goalObj = reloadProtocol
    }
}

struct CBTestA: CBReloadDataProtocol {
    func reloadData(object: String?, error: NSError?) {
        print("\(object ?? "")" + "====CBTestA")
    }
}

struct CBTestB: CBReloadDataProtocol {
    func reloadData(object: Int?, error: NSError?) {
        print("\(object ?? 0)=======CBTestB")
    }
}

let testA = CBTestA()
let testB = CBTestB()

let arr1: [Any] = [testA, testB]
let arr2: [CBReloadDataProtocolThunk<String>] = [CBReloadDataProtocolThunk(testA)]


arr2.forEach { (reloadDataProtocol) in
    reloadDataProtocol.reloadData(object: "aaaaa", error: nil)
}



protocol Initializable {
    init()
    
    func attack() -> Self
}

protocol InitializableSubItem: Initializable {
    
}

class Pokemon<Power: InitializableSubItem> {
    func attack() -> InitializableSubItem {
        return Power()
    }
}






//: [Next](@next)
