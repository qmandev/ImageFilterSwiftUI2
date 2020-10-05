//
//  ContentView.swift
//  ImageFilterSwiftUI2
//
//  Created by Qiang Ma on 10/4/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            
            Home() // darkMode..
                .navigationBarTitle("Filter")
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
