//: [Previous](@previous)

import Foundation

enum Feature {
    case armored
    case ventilated
}

class Container {
    let features: [Feature]
    private(set) var drums: [Drum] = []
    
    init(features: [Feature]) {
        self.features = features
    }
    
    func add(_ drum: Drum) {
        drums.append(drum)
    }
    
    func canAccommodate(_ drum: Drum) -> Bool {
        return drum.specification.isSatisfied(by: self)
    }
}

struct Drum {
    var specification: ContainerSpecification
}

struct ContainerSpecification: Specifying {
    
    let required: Feature
    
    func isSatisfied(by candidate: Container) -> Bool {
        return candidate.features.contains(required)
    }
}

protocol WarehousePacker {
    
    func pack(containersToFill containers: [Container], drumsToPack drums: [Drum])
}

class DefaultWarehousePacker: WarehousePacker {
    
    func pack(containersToFill containers: [Container], drumsToPack drums: [Drum]) {
        
        for drum in drums {
            
            if let container = findContainer(containers, for: drum) {
                
                container.add(drum)
            }
        }
    }
    
    private func findContainer(_ containers: [Container], for drum: Drum) -> Container? {
        
        for container in containers {
            if container.canAccommodate(drum) {
                return container
            }
        }
        
        return nil
    }
}


//: [Next](@next)
