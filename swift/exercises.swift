import Foundation
extension BinarySearchTree: CustomStringConvertible {}


struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

func firstThenLowerCase(of array: [String], satisfying predicate: (String) -> Bool) -> String? {
    if let match = array.first(where: predicate) {
        return match.lowercased()
    } else {
        return nil
    }
}

class Say {
    private var words: [String]

    init(_ word: String = "") {
        words = [word]
    }

    private init(words: [String]) {
        self.words = words
    }

    func and(_ word: String) -> Say {
        var newWords = self.words
        newWords.append(word)
        return Say(words: newWords)
    }

    var phrase: String {
        return words.joined(separator: " ")
    }
}

func say(_ word: String = "") -> Say {
    return Say(word)
}

// Write your meaningfulLineCount function here
func meaningfulLineCount(_ fileName: String) async -> Result<Int, Error> {
    do {
        // create a URL from the file path
        let fileURL = URL(fileURLWithPath: fileName)
        
        // open the file and read lines asynchronously
        var count = 0
        for try await line in fileURL.lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.isEmpty && !trimmed.hasPrefix("#") {
                count += 1
            }
        }
        
        return .success(count)
        
    } catch {
        return .failure(error)
    }
}
 

struct Quaternion: CustomStringConvertible, Equatable {
    let a,b,c,d: Double 
    // static constants 
    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0) 
    static let ONE = Quaternion(a: 1, b: 0, c: 0, d: 0) 
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)   
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)  
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)  
    // initializer but defualt so any part can be omitted
    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
            // returns the quaternion's coefficients as an array 
    var coefficients: [Double] {
        return [a, b, c, d]
    }
    // returns the conjugate of the quaternion (negates the imaginary parts)
    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }
     // addition 
    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }
    // multiplication 
    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            a: lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d,  // Real part
            b: lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c,  // i part
            c: lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b,  // j part
            d: lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a   // k part
        )
    }
    // equal check between two quaternions
    static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return abs(lhs.a - rhs.a) < 1e-10 &&
               abs(lhs.b - rhs.b) < 1e-10 &&
               abs(lhs.c - rhs.c) < 1e-10 &&
               abs(lhs.d - rhs.d) < 1e-10
    }
    // provides a string representation of the quaternion, omitting zero parts
    var description: String {
        var parts: [String] = []
        if a != 0 {
            parts.append("\(a)") 
        }
        if b != 0 {
            // append i part 
            parts.append(b == 1 ? "i" : (b == -1 ? "-i" : "\(b)i"))
        }
        if c != 0 {
            // append j part 
            parts.append(c == 1 ? "j" : (c == -1 ? "-j" : "\(c)j"))
        }
        if d != 0 {
            // append k part 
            parts.append(d == 1 ? "k" : (d == -1 ? "-k" : "\(d)k"))
        }
        // join parts
        return parts.isEmpty ? "0" : parts.joined(separator: "+").replacingOccurrences(of: "+-", with: "-")
    }
}



enum BinarySearchTree: Equatable {
    case empty
    indirect case node(BinarySearchTree, String, BinarySearchTree)
    
    // prop to calculate the size of the tree
    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return 1 + left.size + right.size
        }
    }
    
    // checl if the tree contains a specific value
    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, v, right):
            if value == v {
                return true
            } else if value < v {
                return left.contains(value)
            } else {
                return right.contains(value)
            }
        }
    }
    // insert a new value into the tree
    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, value, .empty)
        case let .node(left, v, right):
            if value < v {
                return .node(left.insert(value), v, right)
            } else if value > v {
                return .node(left, v, right.insert(value))
            } else {
                return self // No duplicates in BST
            }
        }
    }
    
    // custom string representation of the tree
    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(.empty, v, .empty):
            return "(\(v))"
        case let .node(left, v, .empty):
            return "(\(left.description)\(v))"
        case let .node(.empty, v, right):
            return "(\(v)\(right.description))"
        case let .node(left, v, right):
            return "(\(left.description)\(v)\(right.description))"
        }
    }

    // equatable conformance
    static func == (lhs: BinarySearchTree, rhs: BinarySearchTree) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.node(left1, value1, right1), .node(left2, value2, right2)):
            return value1 == value2 && left1 == left2 && right1 == right2
        default:
            return false
        }
    }
}
