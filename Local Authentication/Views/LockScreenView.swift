//
//  LockScreen.swift
//  Local Authentication
//
//  Created by Luis Manuel Ramirez Vargas on 16/01/23.
//

import SwiftUI

struct LockScreenView<Content: View>: View {
    // Estado que indica si la vista esta desbloqueada o no
    @State private var isUnlocked = false
    // Accede a la fase de escena actual
    @Environment(\.scenePhase) var scenePhase
    
    // Contenido a mostrar
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Group {
            // Si la vista esta desbloqueada, muestra el contenido
            if isUnlocked {
                content
            } else {
                // Si no esta desbloqueada, muestra una vista para desbloquear con biometría
                UnlockWithBiometricsView(action: authenticateWithBiometrics)
            }
        }
        // Escucha el cambio de fase de escena
        .onChange(of: scenePhase) { newPhase in
            // Si la fase cambia a background, bloquea el contenido
            if newPhase == .background {
                isUnlocked = false
            }
        }
    }

    func authenticateWithBiometrics() {
        // Llama al servicio de autenticación local para autenticar con biometría
        LocalAuthenticationService.authenticateWithBiometrics { result in
            switch result {
            case .success():
                // Si es exitosa, desbloquea la vista
                isUnlocked = true
            case .failure(let error):
                // Si falla, imprime el mensaje de error
                print(error.localizedDescription)
            }
        }
    }
}

struct LockScreen_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView {
            Text("Esto es el contenido protegido.")
        }
    }
}
