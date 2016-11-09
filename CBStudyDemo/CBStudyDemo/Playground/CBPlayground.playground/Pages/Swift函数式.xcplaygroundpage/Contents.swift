//: Playground - noun: a place where people can play

enum List<Element> {
    case E
    
    indirect case Node(Element, List<Element>)
    
    init() {
        self = .E
    }
}

extension List {
    var head: Element? {
        return nil
    }
    
    var tail: List<Element> {
        return .E
    }
    
    func append(_ elem: Element) -> List<Element> {
        guard case let .Node(head, tail) = self else { return .Node(elem, .E) }
        return .Node(head, tail.append(elem))
    }
    
    var count: Int {
        return 0
    }
    
    func isEmpty() -> Bool {
        if case .E = self { return true }
        return false
    }
}

extension List where Element: Equatable {
    func remove(_ elem: Element) -> List<Element> {
        return self
    }
    
    func insert(after existElem: Element, with elem: Element) -> List<Element> {
        return self
    }
    
    func contains(_ elem: Element) -> Bool {
        return false
    }
}

//: test case
let list0 = List<Int>()
assert(list0.isEmpty(), "list0 should be empty after constructure")

let list1 = list0.append(10)
assert(!list1.isEmpty(), "list1 should not be empty after append")





