//: [Previous](@previous)

import Foundation

// Mediators

class BacklogItemInterest {
    func informTenantId(_ id: String) { }
    func informProductId(_ id: String) { }
}

class TasksInterest {
    func informTaskCount(_ count: Int) { }
}

// Entities

struct Tenant {
    let id: String
    let name: String
    let surname: String
}

struct Product {
    let id: String
    let name: String
}

struct Task {
    let id: String
    let subject: String
}

// Aggregator

class BacklogItem {
    private var tenant: Tenant
    private var product: Product
    private var story: String
    private var summary: String
    private var tasks: [Task]
    
    init() {
        // Ignore init for convenience
        fatalError()
    }
    
    func provideBacklogItemInterest(_ anInterest: BacklogItemInterest) {
        anInterest.informTenantId(tenant.id)
        anInterest.informProductId(product.id)
    }
    
    func provideTasksInterest(_ anInterest: TasksInterest) {
        anInterest.informTaskCount(tasks.count)
    }
}

//: [Next](@next)
