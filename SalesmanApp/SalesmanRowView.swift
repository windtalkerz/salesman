//
//  SalesmanListItemView.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import SwiftUI

fileprivate extension Color {
    static let circleBackground = Color(hex: "#EFEFEF")
    static let circleLineSectionExpanded = Color(hex: "#8D15151F")
    static let circleLineSectionCollapsed = Color(hex: "#15438D1F")
    static let name = Color(hex: "#000000")
    static let areas = Color(hex: "#999999")
}

struct SalesmanRowView: View {
    let item: Salesman
    @State var collapsed = true
    
    var circleStrokeColor: Color {
        return collapsed ? Color.circleLineSectionCollapsed : Color.circleLineSectionExpanded
    }
    
    var firstLetterOfName: String {
        guard let first = item.name.first else {
            return ""
        }
        return String(first)
    }
    
    var name : String {
        return item.name
    }
    
    var areas: String {
        let firstArea = ""
        return item.areas.reduce(firstArea) { (concatenatedAreas: String, nextArea: String) in
            return concatenatedAreas + "" + nextArea
        }
    }
    
    /**
     https://sfsymbols.com/
     */
    var icon: Image {
        
        
        let down = Image(systemName: "chevron.down")
        let right = Image(systemName: "chevron.right")
        
        return collapsed ? down : right
    }
    
    var body: some View {
        
        HStack {
            Text(firstLetterOfName)
                .frame(width: 43, height: 42, alignment: .center)
                .font(.custom("SF Pro", size: 20).weight(.regular))
                .lineSpacing(20)
                .foregroundColor(Color.name)
                .background(Color.circleBackground)
                .clipShape(Circle())
                .overlay(Circle().stroke(circleStrokeColor, lineWidth: 1))
            
            
            VStack(alignment: .leading, spacing: 0){
                Text(name)
                    .frame(height: 22, alignment: .top)
                    .font(.custom("SF Pro", size: 17).weight(.bold))
                    .foregroundColor(Color.name)
                
                Text(areas)
                    .font(.custom("SF Pro", size: 15).weight(.bold))
                    .foregroundColor(Color.areas)
            }
            
            Spacer()
            
            icon
            
//            Button {
//                print("toggle cell collapsing")
//                collapsed = !collapsed
//            } label: {
//                Text("^")
//            }.padding(20)
        }
    }
}

struct SalesmanListItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        let salesmen = FakeSalesmanRepository().getSalesmen().first!
        
        SalesmanRowView(item: salesmen)
    }
}


