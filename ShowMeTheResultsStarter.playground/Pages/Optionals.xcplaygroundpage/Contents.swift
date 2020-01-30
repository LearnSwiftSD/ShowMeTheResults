/*:
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
 
 # A Familiar Type, The Optional
 
 So often times the best way to learn something new is to relate it to something we already know. If you've been working with Swift already
 then you know that the Optional type is pervasive throughout the language. Using and working with the ergonomics of this type has likely
 become second nature to many us.
 
 The Result type is almost identical in it's implementation to the Optional type with only one small but powerful difference. For that reason,
 let's take a look at some of the features of the optional type in order to better understand the Result type
 
 ___
 ## What is it?
 
 ### - Inside the Standard Library with `Optional`
 
 Did you know that when it comes down to it, the Optional is a pretty simple type. Here's the implementation straight from the Swift Open
 Source project. You can find this in the Standard Library (Path: swift/stdlib/public/core/Optional.swift).
 
 ![Optional Swift Standard Lib](OptionalDef.png "Swift Optional Implementation")
 
 The `Optional<Wrapped>` helps us to logically model scenarios where we have either Some value or nothing. You can think of these
 cases like channels or paths that a given situation can travel through. There's a happy path and a not so happy path.
 
 ___
 ## What's it do for us?
 
 ### - Here's a Couple of Scenarios
 A Documented, but unsafe function
 `func unsafeDoublesASingle(digit: Int) -> Int`
 */



//: We can nest, compose, and pass around our functions because in Swift they are first class citizens



//: What's a safer way to model this behavior?
//: `func doublesASingle(digit: Int) -> Int?`



//: Its now safer being wrapped in the `Optional` container, but we've lost our composition 😭



//: We can unwrap each optional, but the boilerplate code beggs for a more ergonomic solution



//: We can use the nil-coalescing operator `??`, but it can give us some unexpected results and doesn't quite get us there.



/*:
 ___
 ## Operating along the path
 
 The `Optional<Wrapped>` type is a monadic type, which in oversimplified terms *(queue screaming of category theorists)* is a type
 that facilitates operations on wrapped values while maintaining a wrapped state. These operators are the `map` and `flatMap`
 operators.
 
 Remembering that the cases can be thought of as paths, the `map` and `flatMap` operators allows us to operate on the
 `Optional<Wrapped>`'s happy path, the `.some(Wrapped)` case.
 
 ### - Inside the Standard Library with `map`
 ![Optional map Swift Standard Lib](OptionalMap.png "Swift Optional Map Implementation")
 
 When the happy path is taken on the `Optional` type `map` will facilitate a transform to the `Wrapped` value without the need to
 unwrap 🎉. If the `Optional` is in the not so happy path state (`.none`) the transform is simply disreguarded.
 
 ### - Optional.map in motion
 
 Let's say we want to create a gated (or clamped) version of our doubler so that the outputs would be more palletable as inputs. We'll need
 to create a transform to supply to the map operator of the `Optional<Int>` type. Let's start with
 `func clamping(value: Int, with range: Range<Int>) -> Int`
 */




/*:
 However the type signature of `(Int, Range<Int>) -> Int` doesn't quite fit with the `Optional.map` signature of
 `(Wrapped) throws -> U` so we'll have to use a couple of functional tricks, one of which has been popularized by and
 named after Haskell Curry.
 */




//: Now we can create our `func gatedOutputDoubler(digit: Int) -> Int?`






//: The `Optional.map` can also be used to create side-effects





/*:
 
 ### - Inside the Standard Library with `flatMap`
 
 ![Optional flatMap Swift Standard Lib](OptionalFlatMap.png "Swift Optional flatMap Implementation")
 
 On the other hand, the `flatMap` operator has the special ability overtake the existing context with a newly inserted one. This allows
 you to easily *flatten* nested `Optional<Optional<Wrapped>>` types into a single `Optional<Wrapped>` type. If you find
 yourself wanting to transform the `Wrapped` value of an `Optional` into something that may produce an `Optional`, you'll want
 to reach for the `flatMap`.
 
 ### - Optional.flatMap in motion
 */







/*:
 ### - What About Context?
 
 FlatMapping optionals is great but what about when we start traveling along the not so happy path? The `nil` value doesn't
 communicate much about what went wrong. If we want more context carried along with what went wrong, we'll have to use another
 convention used in Swift. Swift's error throwing convention.
 */





/*:
 It's awesome that we've regained contextual information about what went wrong, but it feels like it came at the cost loosing the
 ergonomics of the `Optional<Wrapped>` type. Not to mention the do-try-catch mechanism seems clumbsy. Not to worry there is a
 type that facilitates bringing these two worlds together.
 ___
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
 */
