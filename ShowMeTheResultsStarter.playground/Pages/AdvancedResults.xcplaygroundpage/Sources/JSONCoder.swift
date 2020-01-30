import Foundation

public struct JSON {
    
    public enum CodingError: Error {
        public typealias DecodingContext = DecodingError.Context
        public typealias EncodingContext = EncodingError.Context
        
        case dataCorrupted(DecodingContext)
        case keyNotFound(CodingKey, DecodingContext)
        case typeMismatch(Any.Type, DecodingContext)
        case valueNotFound(Any.Type, DecodingContext)
        case invalidValue(Any, EncodingContext)
        case uncategorized(String)
     
        public static func transform(error: DecodingError) -> CodingError {
            switch error {
            case let .dataCorrupted(context):
                return .dataCorrupted(context)
            case let .keyNotFound(codingKey, context):
                return .keyNotFound(codingKey, context)
            case let .typeMismatch(type, context):
                return .typeMismatch(type, context)
            case let .valueNotFound(type, context):
                return .valueNotFound(type, context)
            @unknown default:
                return .uncategorized("Unknown Case: \(error)")
            }
        }
        
        public static func transform(error: EncodingError) -> CodingError {
            switch error {
            case let .invalidValue(anyValue, context):
                return .invalidValue(anyValue, context)
            @unknown default:
                return .uncategorized("Unknown Case: \(error)")
            }
        }
        
    }
    
}
