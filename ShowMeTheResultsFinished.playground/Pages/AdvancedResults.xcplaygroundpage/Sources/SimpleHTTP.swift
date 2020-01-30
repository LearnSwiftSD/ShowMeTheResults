import Foundation

public enum HTTPError: Error {
    case requestFailed(String)
    case malformedRequest(String)
    
    public var message: String {
        switch self {
        case let .requestFailed(errorMessage):
            return "*** Request Failed ***\n\(errorMessage)"
        case let .malformedRequest(errorMessage):
            return "*** Malformed Request ***\n\(errorMessage)"
        }
    }
    
}

public struct HTTP {
    
    private static let successRange = 200..<300
    private static let isSuccess: (Int) -> Bool = { HTTP.successRange.contains($0) }
    private static let session = URLSession.shared
    
    public static func get(
        request: String,
        handler: @escaping (Result<Data, HTTPError>) -> Void
    ) -> () -> Void {
        { _get(request: request, handler: handler) }
    }
    
    private static func _get(
        request: String,
        handler: @escaping (Result<Data, HTTPError>) -> Void
    ) {
        
        guard let urlRequest = (URL(string: request)
            .flatMap { URLRequest(url: $0) }) else {
            return handler(.failure(.malformedRequest(request)))
        }
        
        return session.dataTask(with: urlRequest) { data, response, error in
            
            let (isSuccessful, status) = response
                .flatMap { $0 as? HTTPURLResponse }
                .map { $0.statusCode }
                .map { (isSuccess($0), "STATUS \($0)") }
                ?? (false, "NO STATUS")
            
            guard let error = error, !isSuccessful else {
                let data = data ?? Data()
                return handler(.success(data))
            }
            
            let errorString = ["-> " + status, "-> " + error.localizedDescription].joined(separator: "\n")
            return handler(.failure(.requestFailed(errorString)))
            
        }.resume()
    }
    
}
