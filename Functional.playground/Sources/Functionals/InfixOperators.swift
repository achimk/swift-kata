import Foundation

precedencegroup PrecedenceLeft {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

precedencegroup PrecedenceRight {
    associativity: right
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

// Compose Operator

infix operator >-> :PrecedenceLeft

infix operator <-< :PrecedenceRight

// Pipe Operator

infix operator |> :PrecedenceLeft

// Bind Operator

infix operator >>- :PrecedenceLeft

infix operator -<< :PrecedenceRight
