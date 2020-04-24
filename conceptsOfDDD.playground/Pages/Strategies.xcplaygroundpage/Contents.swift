import Foundation

// MARK: - Strategies

typealias Money = Int

protocol RabatePolicy {
    func calculate(_ order: Order) -> Money
}

protocol TaxPolicy {
    func calculate(_ order: Order) -> Money
}

// MARK: Order Sample

typealias OrderId = Int
typealias OrderItemId = Int

struct OrderItem {
    let id: OrderItemId
    let title: String
    let description: String?
}

struct Order {
    let id: OrderId
    let items: [OrderItem]
}

final class OrderService {
    
    let rabatePolicy: RabatePolicy
    let taxPolicy: TaxPolicy
    
    init(rabatePolicy: RabatePolicy, taxPolicy: TaxPolicy) {
        self.rabatePolicy = rabatePolicy
        self.taxPolicy = taxPolicy
    }
    
    func submit(_ order: Order) {
        let rabate = rabatePolicy.calculate(order)
        let tax = taxPolicy.calculate(order)
        //...
    }
}

// MARK: - Decorated Rabate Strategy

struct VipRabatePolicy: RabatePolicy {
    let other: RabatePolicy?
    
    func calculate(_ order: Order) -> Money {
        // calculate vip
        return 0
    }
}

struct WinterRabatePolicy: RabatePolicy {
    let other: RabatePolicy?
    
    func calculate(_ order: Order) -> Money {
        // calculate winter
        return 0
    }
}

let rabate = VipRabatePolicy(other: WinterRabatePolicy(other: nil))

// MARK: - Chain of Responsability

protocol ChargePolicy: TaxPolicy {
    var next: ChargePolicy? { get set }
}

struct SimpleChargePolicy: ChargePolicy {
    var next: ChargePolicy?
    func calculate(_ order: Order) -> Money {
        // calculate simple
        return 0
    }
}

struct ForeignChargePolicy: ChargePolicy {
    var next: ChargePolicy?
    func calculate(_ order: Order) -> Money {
        // calculate foreign
        return 0
    }
}

var chargePolicy = SimpleChargePolicy()
chargePolicy.next = ForeignChargePolicy()

// MARK: - Agent (Proxy)

protocol TaxHandler: TaxPolicy {
    func canHandler(_ order: Order) -> Bool
}

struct TaxProxy: TaxPolicy {
    
    var handlers: [TaxHandler]
    
    func calculate(_ order: Order) -> Money {
        for handler in handlers {
            if handler.canHandler(order) {
                return handler.calculate(order)
            }
        }
        return 0
    }
}

struct SimpleTaxHandler: TaxHandler {
    
    func canHandler(_ order: Order) -> Bool {
        return true
    }
    
    func calculate(_ order: Order) -> Money {
        return 0
    }
}


let taxCalculator = TaxProxy(handlers: [SimpleTaxHandler()])
