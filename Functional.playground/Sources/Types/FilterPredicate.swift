import Foundation

public typealias FilterPredicate<T> = (T) -> Bool

public func composeFilter<T>(
    _ f: @escaping FilterPredicate<T>,
    _ g: @escaping FilterPredicate<T>) -> FilterPredicate<T> {
    
    return { x in
        f(x) ? g(x) : false
    }
}

public func composeFilter<T>(
    _ f: @escaping FilterPredicate<T>,
    _ g: @escaping FilterPredicate<T>,
    _ h: @escaping FilterPredicate<T>) -> FilterPredicate<T> {
    
    return { x in
        composeFilter(f, g)(x) ? h(x) : false
    }
}

public func composeFilter<T>(
    _ f: @escaping FilterPredicate<T>,
    _ g: @escaping FilterPredicate<T>,
    _ h: @escaping FilterPredicate<T>,
    _ i: @escaping FilterPredicate<T>) -> FilterPredicate<T> {
    
    return { x in
        composeFilter(f, g, h)(x) ? i(x) : false
    }
}

public func composeFilter<T>(
    _ f: @escaping FilterPredicate<T>,
    _ g: @escaping FilterPredicate<T>,
    _ h: @escaping FilterPredicate<T>,
    _ i: @escaping FilterPredicate<T>,
    _ j: @escaping FilterPredicate<T>) -> FilterPredicate<T> {
    
    return { x in
        composeFilter(f, g, h, i)(x) ? j(x) : false
    }
}

public func composeFilter<T>(
    _ f: @escaping FilterPredicate<T>,
    _ g: @escaping FilterPredicate<T>,
    _ h: @escaping FilterPredicate<T>,
    _ i: @escaping FilterPredicate<T>,
    _ j: @escaping FilterPredicate<T>,
    _ k: @escaping FilterPredicate<T>) -> FilterPredicate<T> {
    
    return { x in
        composeFilter(f, g, h, i, j)(x) ? k(x) : false
    }
}

public func composeFilter<T>(
    _ f: @escaping FilterPredicate<T>,
    _ g: @escaping FilterPredicate<T>,
    _ h: @escaping FilterPredicate<T>,
    _ i: @escaping FilterPredicate<T>,
    _ j: @escaping FilterPredicate<T>,
    _ k: @escaping FilterPredicate<T>,
    _ l: @escaping FilterPredicate<T>) -> FilterPredicate<T> {
    
    return { x in
        composeFilter(f, g, h, i, j, k)(x) ? l(x) : false
    }
}
