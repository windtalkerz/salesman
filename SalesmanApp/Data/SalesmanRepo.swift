//
//  SalesmanRepo.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import Foundation

protocol SalesmanRepository{
    func getSalesmen()->[Salesman]
//    func addSalesman(salesman: Salesmen) -> Salesmen
//    func updateSalesman(salesman: Salesmen) -> Salesmen
}

class FakeSalesmanRepository: SalesmanRepository {
    
    func getSalesmen() -> [Salesman] {
        let fakedSalesmanJSON = """
                [
                {"name":"Artem Titarenko", "areas": ["76133"]}, {"name":"Bernd Schmitt", "areas": ["7619*"]}, {"name":"Chris Krapp", "areas": ["762*"]}, {"name":"Alex Uber", "areas": ["86*"]}
                ]
                """
        
//        let fakedSalesmanJSON = """
//                [
//                {"name":"Artem Titarenko", "areas": ["76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133", "76133"]}, {"name":"Bernd Schmitt", "areas": ["7619*"]}, {"name":"Chris Krapp", "areas": ["762*"]}, {"name":"Alex Uber", "areas": ["86*"]}
//                ]
//                """
        
        guard
            let jsonData = fakedSalesmanJSON.data(using: .utf8),
            let salesman: [Salesman] = try? JSONDecoder().decode([Salesman].self, from: jsonData)
        else {
            return []
        }

        return salesman
    }
}


