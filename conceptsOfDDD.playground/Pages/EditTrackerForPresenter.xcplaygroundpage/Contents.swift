//: [Previous](@previous)

import Foundation

class BacklogItem {
    let summary: String
    let type: String
    init(summary: String, type: String) {
        self.summary = summary
        self.type = type
    }
}

class BacklogItemApplicatonService {
    func changeSummary(_ summary: String, with type: String) {
    }
}

class EditTracker {
    var summary: String { didSet { isChanged = true } }
    var type: String { didSet { isChanged = true } }
    private(set) var isChanged: Bool = false
    
    init(_ item: BacklogItem) {
        self.summary = item.summary
        self.type = item.type
    }
}

class BacklogItemPresenter {
    private let item: BacklogItem
    private let editTracker: EditTracker
    private let service: BacklogItemApplicatonService
    
    init() {
        // ignore for convenience
        fatalError()
    }
    
    func changeSummaryWithType() {
        if editTracker.isChanged {
            service.changeSummary(editTracker.summary, with: editTracker.type)
        }
    }
}


//: [Next](@next)
