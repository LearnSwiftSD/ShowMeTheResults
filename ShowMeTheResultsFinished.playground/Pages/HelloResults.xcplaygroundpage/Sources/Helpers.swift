import Foundation

public func clamping(value: Int, with range: Range<Int>) -> Int {
    guard range.lowerBound != range.upperBound else {
        return range.upperBound
    }
    switch value {
    case let x where x >= range.upperBound:
        return range.upperBound - 1
    case let x where x < range.lowerBound:
        return range.lowerBound
    default:
        return value
    }
}

public func curry<A, B, R>(
    _ f: @escaping (A, B) -> R
) -> (A) -> (B) -> R {
    return { a in { b in f(a,b) } }
}

public func flip<A, B, R>(
    _ f: @escaping (A) -> (B) -> R
) -> (B) -> (A) -> R {
    return { b in { a in f(a)(b) } }
}

public let clampedBy = flip(curry(clamping(value:with:)))

public enum DoublesASingleDigitError: Error {
    case notASingleDigit(Int)
    
    public var message: String {
        switch self {
        case let .notASingleDigit(digit):
            return "\(digit) is not a single digit!"
        }
    }
}
