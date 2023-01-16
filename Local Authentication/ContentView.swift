//
//  ContentView.swift
//  Local Authentication
//
//  Created by Luis Manuel Ramirez Vargas on 16/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            // Envuelve el contenido en un LockScreenView
            LockScreenView {
                // Contenido
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hello, world!")
                }
                .padding()
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
