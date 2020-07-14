import UIKit

// The Problem that generics solve

func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tempA = a
    a = b
    b = tempA
}

var someInt = 3
var anotherInt = 107

var someString = "Himanshu"
var anotherString = "Rajput"

var someDouble = 3.0
var anotherDouble = 170.0

swapTwoInts(&someInt, &anotherInt)

func swapTwoString(_ a: inout String, _ b: inout String) {
    let tempA = a
    a = b
    b = tempA
}

func swapTwoDouble(_ a: inout Double, _ b: inout Double) {
    let tempA = a
    a = b
    b = tempA
}

// Generic Functions

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let tempA = a
    a = b
    b = tempA
}

swapTwoValues(&someInt, &anotherInt)
swapTwoValues(&someString, &anotherString)
swapTwoValues(&someDouble, &anotherDouble)

// Type Parameters

/*
 In above example T is a type parameter, you can add other generic type by writing multiple type parameter saparated by commas.
 */

// Naming Type Parameters

/*
 Naming can be as you want which can describe your variable such as Array<Element>, Dictionary<Key, Value>. If nothing is clear then traditional name using single digit T, U, V.
 */

//-------------------------------------------------------------------------------------//

// Generic Types

// - Normal
struct IntStack {
    var items = [Int]()

    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop(_ item: Int) {
        items.removeLast()
    }
}

// - Generic
struct Stack<Element> {
    var items = [Element]()

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("Himanshu")
stackOfStrings.push("Shivanshu")
stackOfStrings.push("Aman")
stackOfStrings.push("Ayush")

let fromTheTop = stackOfStrings.pop()

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem)")
}

//-------------------------------------------------------------------------------------//
// Type constraints

/*
 Documentation
 */

// Type constraint Syntax

//func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
//    // Function body goes here
//}

// Type constraints in Action

func findIndex(ofString valueToFind: String, is array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", is: strings) {
    print("The index of llama is \(foundIndex)")
}

func findIndex<T: Equatable>(of valueToFind: T, is array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, is: [3.14, 0.1, 0.25])
let stringIndex = findIndex(of: "llama", is: strings)

//-------------------------------------------------------------------------------------//

// Associated Types

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct IntStack2: Container {
    
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop(_ item: Int) {
        items.removeLast()
    }
    
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
}

struct Stack2<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

//-------------------------------------------------------------------------------------//

// Extending an Existing Type to specify an Associated Type

extension Array: Container {}

//-------------------------------------------------------------------------------------//

// Adding constraints to an Associated Type

protocol ContainerAssociatedType {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

//-------------------------------------------------------------------------------------//

// Using Protocol in its Associated Type's Constraints

protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}
//
//extension Stack2: SuffixableContainer {
//    func suffix(_ size: Int) -> Stack {
//        var result = Stack()
//        for index in (count-size)..<count {
//            result.append(self[index])
//        }
//        return result
//    }
//    // Inferred that Suffix is Stack.
//}
