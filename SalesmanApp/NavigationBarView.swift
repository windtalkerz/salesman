//
//  NavigationBarView.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import SwiftUI
// #00327FF0

fileprivate extension Color {
    static let title = Color(hex: "#FFFFFF")
    static let background = Color(hex: "#00327FF0")
    static let chevron = Color(hex: "#EFEFEF")
}

struct NavigationBarView: View {
    var body: some View {
        
        ZStack() {
            Rectangle()
                .fill(Color.background)
                //.frame(width: 200, height: 200)
            
            HStack(){
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 26)
                    .foregroundColor(Color.chevron)
                    .padding(.leading, 20)
                
                Spacer()
                
                Text("Adressen")
                    //.frame(height: 22, alignment: .top)
                    .font(.custom("SF Pro", size: 15).weight(.semibold))
                    .lineSpacing(18)
                    .foregroundColor(Color.title)
                
                Spacer()
                    
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 26)
                    .foregroundColor(Color.chevron)
                    .padding(.trailing, 20)
                    .hidden()
            }
        }
        
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView()
    }
}
