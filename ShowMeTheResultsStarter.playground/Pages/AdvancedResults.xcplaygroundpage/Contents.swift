/*:
[Home](Welcome) | [Previous](@previous) | [Next](@next)

# Advanced Results

The `Result` type is a very powerful type and can unlock a lot of powerful features. Let's start to leverage the power of this type.
 
___
## Extending Results
*/
import Foundation

extension Result {
    
    /// Boolean representation
    var isSuccessful: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Optional representation
    var optional: Success? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Map ignoring the recieved value
    func transform<NewSuccess>(to newSuccess: NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
         case .success:
            return .success(newSuccess)
         case let .failure(error):
            return .failure(error)
         }
    }
    
    /// Do side-effects in an explicit way
    @discardableResult
    func `do`(
        onFailure: @escaping (Failure) -> Void = { _ in  },
        onSuccess: @escaping (Success) -> Void
    ) -> Result<Success, Failure> {
        switch self {
        case let .success(value):
            onSuccess(value)
            return .success(value)
        case let .failure(error):
            onFailure(error)
            return .failure(error)
        }
    }
    
    /// Type lifting when Compiler inference is available
    static func pure(_ value: Success) -> Result<Success, Failure> {
        return .success(value)
    }
    
    /// Type lifting when Compiler inference is not available
    static func pure(failedBy: Failure.Type, _ value: Success) -> Result<Success, Failure> {
        return .success(value)
    }
    
}

// Result Failure Coalescing Operator
public func ?? <A, Err: Swift.Error>(
    _ result: Result<A, Err>,
    _ defaultValue: @autoclosure () -> A
    ) -> A {
    switch result {
    case let .success(value):
        return value
    case .failure:
        return defaultValue()
    }
}

//: Lets try out some of our new extensions here 🧪⚗️🔬







//: ___
//: ## Results based Codable
/// Wrapped Codable for JSON
extension JSON {
    
    public static func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Result<T, CodingError> {
        
        do {
            let decoded = try decoder.decode(type.self, from: data)
            return .success(decoded)
        } catch let decodeError as DecodingError {
            return .failure(.transform(error: decodeError))
        } catch {
            return .failure(.uncategorized(error.localizedDescription))
        }
        
    }
    
    public static func encode<T: Encodable>(
        _ value: T,
        using encoder: JSONEncoder = JSONEncoder()
    ) -> Result<Data, CodingError> {
        
        do {
            let serialized = try encoder.encode(value)
            return .success(serialized)
        } catch let encodeError as EncodingError {
            return .failure(.transform(error: encodeError))
        } catch {
            return .failure(.uncategorized(error.localizedDescription))
        }
        
    }

}

/// Sample Value Type to Encode/Decode
struct Person: Codable {
        
    let name: String
    let age: Int
    let hobby: String?
 
    init(name: String, age: Int, hobby: String?) {
        self.name = name
        self.age = age
        self.hobby = hobby
    }
    
    static var empty: Person {
        Person(name: "", age: 0, hobby: nil)
    }
    
}

//: Let make an API call to test out our new Codable JSON
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true







/*:

___
[Home](Welcome) | [Previous](@previous) | [Next](@next)
*/
