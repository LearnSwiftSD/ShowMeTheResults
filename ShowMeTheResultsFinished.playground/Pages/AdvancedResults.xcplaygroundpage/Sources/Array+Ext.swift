import Foundation

public extension Array {
    
    func appended(_ newElement: Element) -> Array<Element> {
        var array = self
        array.append(newElement)
        return array
    }
    
}

public extension Sequence {
    
    func compactMap<NewSuccess, Error: Swift.Error>(
        _ transform: (Element) -> Result<NewSuccess, Error>
    ) -> [NewSuccess] {
        var results: [NewSuccess] = []
        for element in self {
            if case let .success(newElement) = transform(element) {
                results.append(newElement)
            }
        }
        return results
    }
    
}
