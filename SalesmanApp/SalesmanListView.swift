//
//  SalesmanListView.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import SwiftUI
import Combine

extension SalesmanListView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published
        var filteredSalesmen: [Salesman]
        
        private let repository: SalesmanRepository
        
        init(repository: SalesmanRepository) {
            self.repository = repository
            
            filteredSalesmen = repository.getSalesmen()
        }
        
        func updateSalesman(searchQuery: String) {
            print("updateSalesman - searchQuery: \(searchQuery)")
            
            let allSalesmen = repository.getSalesmen()
            filteredSalesmen = allSalesmen.filter({ (salesman: Salesman) in
                
                // filter salesman matching area criteria
                salesman.areas.contains { area in
                    area == searchQuery
                }
            })
        }
    }
}

struct SalesmanListView: View {
    @StateObject
    var viewModel: SalesmanListView.ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.filteredSalesmen, id: \.name) { 
                SalesmanRowView(salesman: $0)
            }
        }
        // iOS16 .scrollContentBackground(.hidden)
        // stretch cells to edges backgroundColor == white
        .listStyle(.plain)
        
    }
}

struct SalesmanListView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = FakeSalesmanRepository()
        let viewModel = SalesmanListView.ViewModel(repository: repository)
        SalesmanListView(viewModel: viewModel)
    }
}

    
