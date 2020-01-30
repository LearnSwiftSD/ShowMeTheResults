import Foundation

public enum MyError: Error {
    case uhOh(String)
    
    public var message: String {
        switch self {
        case let .uhOh(value):
            return "UhOh: \(value)"
        }
    }
    
}
