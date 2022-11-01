//
//  Salesman.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import Foundation

struct Salesman: Codable {
    let name: String
    let areas: [String]
}

extension Salesman: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.areas)
    }
}

extension Salesman: Equatable {
    static func == (lhs: Salesman, rhs: Salesman) -> Bool {
        return lhs.name == rhs.name && lhs.areas == rhs.areas
    }
}


#if DEBUG
// MARK: - Example Item
extension Salesman {
    
    static var example_simple: Salesman {

        Salesman(
            name: "Tom Best",
            areas: ["76133", "86167"]
        )
    }
    
    static var example_manyEaras: Salesman {

        Salesman(
            name: "Tom Best",
            areas: ["76133", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167", "86167"]
        )
    }
}
#endif
