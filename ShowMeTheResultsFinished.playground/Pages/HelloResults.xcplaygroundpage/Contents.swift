/*:
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
 
 # Hello Results
 
 The `Result` type bridges the world of error handling with the ergonomics that you would get from using the `Optional<Wrapped>`
 type. The `Result` type is quite similar to the `Optional<Wrapped>` in that it's an enum with two cases, but it has a few
 important differences that distinguishes itself.
 
 ___
 ## What is it?
 
 ### - Inside the Standard Library with `Result`
 
 Again the Result is a pretty simple type. Here's the implementation straight from the Swift Open Source project. You can find this in the
 Standard Library (Path: swift/stdlib/public/core/Result.swift).
 
 ![Result Swift Standard Lib](ResultDef.png "Swift Result Implementation")
 
 The `Result<Success, Failure>` helps us to logically model scenarios where we are attempting to accomplish a task that can
 either succeed or fail. Similarly to the Optional type, you can think of these cases like paths that a given situation can travel through.
 There's a success path and a failure path.
 
 You may have noticed though, that there are two generic paramters on this type. The Success represents any value that you'd like to pass
 in a successful situation. The Failure is something that conforms to the `Swift.Error` protocol and is passed in the event that the
 scenario is not successful.
 
 ___
 ## What's it do for us?
 
 ### - Let's walk though the scenarios with the Result type
 If you remember the `func doublesASingle(digit: Int) -> Int?`, let's try to reimplement it with the `Result` type.
 */

func doublesASingle(digit: Int) -> Result<Int, DoublesASingleDigitError> {
    let validRange = -9..<10
    switch validRange.contains(digit) {
    case true:
        return .success(2 * digit)
    case false:
        return .failure(.notASingleDigit(digit))
    }
}

let doubleResult = doublesASingle(digit: 10)

//: You can extract the value by using patern matching
switch doubleResult {
case let .success(value):
    print(value)
case let .failure(error):
    print(error.message)
}

//: You can also extract it by traditional error handling
do {
    
    let extractedValue = try doubleResult.get()
    print("Extracted Value -> ", extractedValue)
    
} catch let error as DoublesASingleDigitError {
    
    print(error.message)
    
} catch {
    
    print(error.localizedDescription)
    
}
//: Composable? Not quite yet! We'll get there 👍

let doubler = doublesASingle(digit:)

//doubler(doubler(doubler(2)))

/*:
 ___
 ## Operating along the path
 
 The `Result<Success, Error>` type is also a monadic type and has the `map` and `flatMap` operators. Again, these operators
 allows us to operate on the happy path of the type.
 
 ### - Inside the Standard Library with `map`
 ![Result map Swift Standard Lib](ResultMap.png "Swift Result Map Implementation")
 
 The map operator provided by the `Result<Success, Error>` has all the same, faliliar ability provided to us by the `Optional`
 type.
 ### - Result.map in motion
 
 Let's see a couple of simple and side-effecty examples with map
 */

let thisIsNowAStringResult = doublesASingle(digit: 2).map { "\($0)" }

var sideEffectedStringValue = "Nothing Happened"

_ = doublesASingle(digit: 1).map { sideEffectedStringValue = "Doubled to \($0)" }

print(sideEffectedStringValue)

//: What about our gated doubler? Will that also work with Result?
func gatedOutputDoubler(digit: Int) -> Result<Int, DoublesASingleDigitError> {
    doublesASingle(digit: digit).map(clampedBy(-9..<10))
}

let gatedResult = gatedOutputDoubler(digit: 9)

if case let .success(value) = gatedResult {
    print("Gated Doubler Produced -> ", value)
}
/*:
 
 ### - Inside the Standard Library with `flatMap`
 Nothing new here. Just another plain old `.flatMap` on another monadic type 😃
 
 ![Result flatMap Swift Standard Lib](ResultFlatMap.png "Swift Result flatMap Implementation")
 
 ### - Result.flatMap in motion
 */
_ = gatedOutputDoubler(digit: 5)
    .flatMap(gatedOutputDoubler(digit:))
    .flatMap(doublesASingle(digit:))
    .map { print("Success -> ", $0) }

/*:
 ___
 ## Operating on the "other" path?
 What's all this I keep seeing about `.mapError` and `.flatMapError`? I didn't see these on the `Optional<Wrapped>` type!
 Well, those my friend give us the power to work some magic when erorrs occur. The generic error parameter in the
 `Result<Success, Error>` gives us these extra powers that we didn't have with the optional type.
 
 Ultimately, they do the same exact thing as their normal counterparts except that:
 
 1 - Their transforms are only called when an error occur
 
 2 - The value they operate on is the error value
 
 ### - Result.mapError in motion
 
 First, we'll need a new error type to work with.
 */
enum MyOtherError: Error {
    case uhOh(String)
    
    static func convertFrom(_ doubleError: DoublesASingleDigitError) -> MyOtherError {
        switch doubleError {
        case let .notASingleDigit(value):
            return .uhOh("\(value) isn't a single digit")
        }
    }
    
    var message: String {
        switch self {
        case let .uhOh(value):
            return "UhOh, found: \(value)"
        }
    }
    
}

//: `.mapError` helps with converting a cought error into another error type
let newDoubleResult = doublesASingle(digit: 19)
    .mapError(MyOtherError.convertFrom(_:))

if case let .failure(error) = newDoubleResult {
    print(error.message)
}
/*:
 ### - Result.flatMapError in motion
 
 `.flatMapError` intercepts an error and returns a new Result type. This is very powerful and can even facilitate error recovery for
 more robust API's.
 */
func doublerRecovery(
    _ error: DoublesASingleDigitError
) -> Result<Int, DoublesASingleDigitError> {
    return .success(9)
}

_ = gatedOutputDoubler(digit: 6541651651651)
    .flatMapError(doublerRecovery(_:))
    .flatMap(gatedOutputDoubler(digit:))
    .flatMap(doublesASingle(digit:))
    .map { print("Got Me a recovered result -> ", $0) }

/*:
 Now that you've probably got a good feel for Results, let's take a look a few more advanced usecases/examples.
 ___
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
 */
