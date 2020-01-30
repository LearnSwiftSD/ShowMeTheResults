import Foundation

public extension Optional {
    
    func result<T: Error>(_ errorType: T) -> Result<Wrapped, T> {
        switch self {
        case let .some(value):
            return .success(value)
        case .none:
            return.failure(errorType)
        }
    }
    
}
