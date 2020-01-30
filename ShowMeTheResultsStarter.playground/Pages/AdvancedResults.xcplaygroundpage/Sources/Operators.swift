import Foundation

precedencegroup ForwardApplication {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: EffectfulComposition
}

precedencegroup ApplicativeComposition {
    associativity: left
    higherThan: ForwardComposition
}

infix operator |>: ForwardApplication

infix operator >>>: ForwardComposition

infix operator >=>: EffectfulComposition

infix operator <*>: ApplicativeComposition

infix operator <^>: ApplicativeComposition

public func |> <A, B>(_ a: A, _ f: @escaping (A) -> B ) -> B {
    return f(a)
}

public func >>> <A, B, C>(
    _ lhf: @escaping (A) -> B,
    _ rhf: @escaping (B) -> C
    ) -> (A) -> C {
    return { rhf(lhf($0)) }
}

public func >=> <A, B, C>(
    _ lhf: @escaping (A) -> Optional<B>,
    _ rhf: @escaping (B) -> Optional<C>
    ) -> (A) -> Optional<C> {
    return { a in
        switch lhf(a) {
        case let .some(value):
            return rhf(value)
        case .none:
            return .none
        }
    }
}

public func >=> <A, B, C, Err: Swift.Error> (
    _ lhf: @escaping (A) -> Result<B, Err>,
    _ rhf: @escaping (B) -> Result<C, Err>
) -> (A) -> Result<C, Err> {
    return { a in
        switch lhf(a) {
        case let .success(b):
            return rhf(b)
        case let .failure(err):
            return .failure(err)
        }
    }
}

public func <*> <A, B, Err: Swift.Error>(
    _ f: Result<((A) -> B), Err>,
    _ x: Result<A, Err>
) -> Result<B, Err> {
    return f.flatMap { f in x.map { x in f(x) } }
}

public func <^> <A, B, C, Err: Swift.Error>(
    _ resultf: @escaping (A) -> Result<B, Err>,
    _ f: @escaping (B) -> C
) -> (A) -> Result<C, Err> {
    return { a in resultf(a).map(f) }
}

public func ?? <A, B, Err: Swift.Error>(
    _ resultf: @escaping (A) -> Result<B, Err>,
    _ defaultValue: @escaping @autoclosure () -> B
    ) -> (A) -> B {
    return { a in
        switch resultf(a) {
        case let .success(b):
            return b
        case .failure:
            return defaultValue()
        }
    }
}

public func curry<A, B, R>(
    _ f: @escaping (A, B) -> R
) -> (A) -> (B) -> R {
    return { a in { b in f(a,b) } }
}

public func curry<A, B, C, R>(
    _ f: @escaping (A, B, C) -> R
) -> (A) -> (B) -> (C) -> R {
    return { a in { b in { c in f(a, b, c) } } }
}

public func flip<A, B, R>(
    _ f: @escaping (A) -> (B) -> R
) -> (B) -> (A) -> R {
    return { b in { a in f(a)(b) } }
}
