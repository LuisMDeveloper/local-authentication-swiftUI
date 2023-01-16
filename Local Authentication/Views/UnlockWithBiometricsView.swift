//
//  UnlockButton.swift
//  Local Authentication
//
//  Created by Luis Manuel Ramirez Vargas on 16/01/23.
//

import SwiftUI

struct UnlockWithBiometricsView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                Text("Unlock")
            }
            
        }
        .buttonStyle(.bordered)
    }
}

struct UnlockButton_Previews: PreviewProvider {
    static var previews: some View {
        UnlockWithBiometricsView(action: {})
    }
}
