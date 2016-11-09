//: [Previous](@previous)

import Foundation

indirect enum LinkedList<Element: Comparable> {
    case Empty
    case Node(Element, LinkedList<Element>)
    init() {
        self = .Empty
    }
}

let linkedList = LinkedList.Node(1, .Node(2, .Node(3, .Node(4, .Empty))))

extension LinkedList {
    func linkedListByRemovingElement(element: Element) -> LinkedList<Element> {
        guard case let .Node(value, next) = self else { return .Empty }
        return value == element ? next : LinkedList.Node(value, next.linkedListByRemovingElement(element: element))
    }
}


//: [Next](@next)
