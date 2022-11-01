//
//  ContentView.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import SwiftUI
import Combine

fileprivate extension Color {
    static let searchText = Color(hex: "#3C3C4399")
    static let icons = Color(hex: "#3C3C4399")
    static let searchFieldBackground = Color(hex: "#7676801F")
}

func isValidSearchQuery(_ searchQuery: String) -> Bool {
    guard(searchQuery.count >= 1) else {
        return false
    }
    guard(searchQuery.count <= 5) else {
        return false
    }
    
    return true
}

extension ContentView {
    @MainActor
    class ViewModel: ObservableObject {
        let repository: SalesmanRepository = FakeSalesmanRepository()
        
        @Published var searchQuery: String = ""
        @Published var filteredSalesmen: [Salesman] = []
        
        let placeholderText = "Suche"
        
        var debouncedSearchQueryPublisher: AnyPublisher<String, Never>
        var relay: PassthroughSubject<String, Never>
        
        private var subscriptions = Set<AnyCancellable>()
        
        init() {
            let relay = PassthroughSubject<String, Never>()
            self.relay = relay
            self.debouncedSearchQueryPublisher = relay
                .debounce(for: 1, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
            
//            relay
//                .assign(to: \.searchQuery, on: self)
//                .store(in: &subscriptions)
            
            relay
                .sink(receiveValue: { text in
                    print("sink text: \(text)")
                })
                .store(in: &subscriptions)
            
            /**
                subscribe to debounced textfields search-text
                use text to filter salesman by appropriate salesman.area*
             */
            debouncedSearchQueryPublisher
                .sink(receiveValue: { debouncedSearchQuery in
                    print("debouncedSearchQuery: \(debouncedSearchQuery)")
                    
                    let isValid = isValidSearchQuery(debouncedSearchQuery)
                    let allSalesmen = self.repository.getSalesmen()
                    
                    if(debouncedSearchQuery == "") {
                        print("restore orginal salesman")
                        self.filteredSalesmen = allSalesmen
                        return 
                    }
                    
                    /**
                     The user should be able to search for salesmen by a postcode expression.
                     
                     762* means that all postcodes between 76200 and 76299 are included.
                     */
                    if(isValid) {
                        print("debouncedSearchQuery advanced")
                        
                        let _filteredSalesman = allSalesmen.filter { salesman in
                            
                            salesman.areas.contains(where: { area in
                                
                                guard let index = area.index(of: "*") else {
                                    return area.contains(debouncedSearchQuery)
                                }
                                
                                let slicedArea = String(area[..<index])
                                
                               let offset = min(slicedArea.count, debouncedSearchQuery.count)
                                
                                
                                guard let s = debouncedSearchQuery.index(debouncedSearchQuery.startIndex, offsetBy: offset, limitedBy: debouncedSearchQuery.endIndex)
                                else {
                                    return area.contains(debouncedSearchQuery)
                                }
                                
                                let slicedQuery = String(debouncedSearchQuery[..<s])
                                
                                
                                return slicedArea.contains(slicedQuery)
                            })
                        }
                        
                        
                        self.filteredSalesmen = _filteredSalesman
                    }
                    
                })
                .store(in: &subscriptions)
            
            /**
                subscribe a debugging observer on filteredSalesmen
             */
            $filteredSalesmen.sink {
                print("filteredSalesmen", $0)
            }
            .store(in: &subscriptions)
            
            /**
                Update salesman according to search-text
             */
            filteredSalesmen = repository.getSalesmen()
        }
        
    }
}


struct ContentView: View {
    @StateObject
    var viewModel: ContentView.ViewModel
    

    @State private var textFieldText = ""
//   @State var debouncedTextFieldText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            /*
            ======================= DEBUG_FEEDBACK =======================
             */
//            Text("debouncedTextFieldText: \(debouncedTextFieldText)")
//                .onReceive(viewModel.debouncedSearchQueryPublisher, perform: {
//                    debouncedTextFieldText = $0
//                })
//                .background(Color.yellow)
//
//            Text("viewModel.searchQuery: \(viewModel.searchQuery)")
//                .onReceive(viewModel.searchQuery.publisher, perform: {
//                    print("viewModel.searchQuery.publishersfeefd \($0)")
//                })
//                .background(Color.pink)
            
            /*
             ======================= NAVIGATION_BAR =======================
             */
            NavigationBarView()
                .frame(height: 48, alignment: .top)
                
            /*
             ======================= SEARCH_TEXTFIELD =======================
             */
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.searchFieldBackground)
                    .frame(height: 36)
                
                HStack(alignment: .center, spacing: 0) {
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.icons)
                        .padding(.leading, 6)
                    
                    TextField(viewModel.placeholderText, text: $textFieldText)
                        .frame(height: 20, alignment: .leading)
                        .font(.custom("SF Pro", size: 17).weight(.regular))
                        .lineSpacing(22)
                        .textContentType(.postalCode)
                        .foregroundColor(Color.searchText)
                        .padding(.leading, 8)
                        .onChange(of: textFieldText) {
                            viewModel.relay.send($0)
                        }
                        //.textContentType(.oneTimeCode)
                        .keyboardType(.namePhonePad)
                        
                    Image(systemName: "mic.fill")
                        .foregroundColor(Color.icons)
                        .padding(.trailing, 6)
                }
            }
            .padding(16)
            
            .onAppear(perform: {
               // filteredSalesmen = viewModel.repository.getSalesmen()
                
            })
            
            /*
             ======================= TABLE =======================
             */
            List {
                ForEach(viewModel.filteredSalesmen, id: \.name) {
                    SalesmanRowView(salesman: $0)
                }
            }
            .listStyle(.plain)
            

            
            Spacer()
            
            
            
        }
        .statusBar(hidden: true)
        .navigationBarHidden(true)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contentViewViewModel = ContentView.ViewModel()
        
        Group {
            ContentView(viewModel: contentViewViewModel)
        }
        
    }
}

