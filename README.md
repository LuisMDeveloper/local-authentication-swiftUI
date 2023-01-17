# Autenticación Biométrica en SwiftUI

## Introducción

La tecnología de reconocimiento facial y huella dactilar, como FaceID y TouchID, se ha vuelto cada vez más popular en los dispositivos móviles modernos. En este tutorial, le mostraremos cómo utilizar la funcionalidad de FaceID y TouchID en sus aplicaciones SwiftUI para proporcionar una mayor seguridad y comodidad para sus usuarios.

## LocalAuthentication

```swift
import LocalAuthentication
import Foundation

class LocalAuthenticationService {
    class func authenticateWithBiometrics(_ completion: @escaping (Result<Void, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(AppError.error(error?.localizedDescription ?? "Error Undefined")))
                }
            }
        } else {
            completion(.failure(AppError.error("No Biometrics Available")))
        }
    }
}
```

Este código presenta una clase de Swift llamada `LocalAuthenticationService` que proporciona una forma fácil de utilizar la funcionalidad de autenticación biométrica en su aplicación. El método estático `authenticateWithBiometrics` es el que proporciona la funcionalidad de autenticación. Este método toma una función de retorno de llamada como parámetro que se ejecuta cuando se completa la autenticación.

La función `authenticateWithBiometrics` crea una instancia de LAContext, que es una clase de iOS que proporciona acceso a la funcionalidad de autenticación biométrica. Se comprueba si el dispositivo es compatible con la autenticación biométrica y si el usuario ha configurado una huella dactilar o rostro para usar como medida de seguridad. Si es compatible, se llama al método `evaluatePolicy` en el contexto con el argumento `.deviceOwnerAuthenticationWithBiometrics`. Este método despliega un diálogo para que el usuario pueda autenticarse mediante su huella dactilar o rostro. El argumento `localizedReason` es una cadena que se muestra en el diálogo para indicar al usuario el motivo de la solicitud de autenticación.

El parámetro de `evaluatePolicy` es un bloque de callback que se llama cuando el usuario se ha autenticado. Si el usuario se ha autenticado correctamente, se llama a la función de retorno de llamada con un Resultado de éxito. Si no se autentica correctamente, se llama a la función de retorno de llamada con un Resultado de error. El resultado de error puede ser el error devuelto en caso de fallo en la autenticación o "No Biometrics Available" si el dispositivo no soporta la autenticación biométrica.

Antes de continuar tenemos que agregar la clave `NSFaceIDUsageDescription` a nuestro `Info.plist`, `NSFaceIDUsageDescription` es una clave de `Info.plist` que se utiliza para describir el propósito del uso de la tecnología de reconocimiento facial (Face ID) en la aplicación. Es necesario incluir esta clave en el archivo `Info.plist` de su proyecto si su aplicación utiliza Face ID para la autenticación de usuarios.

La razón de esto es que, de acuerdo con las guías de desarrollo de Apple, todas las aplicaciones que utilizan características privadas del sistema, como Face ID, deben proporcionar una descripción clara y precisa del uso de estas características. Esto proporciona transparencia para los usuarios sobre cómo se utilizará la información biométrica que proporcionan, y les permite tomar una decisión informada.

## LockScreen

Ahora, veamos como podemos usar esta función con un ejemplo:

```swift
import SwiftUI

struct LockScreenView<Content: View>: View {
    // Estado que indica si la vista esta desbloqueada o no
    @State private var isUnlocked = false
    // Accede a la fase/estado de escena actual
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
        // Escucha el cambio de fase/estado de escena
        .onChange(of: scenePhase) { newPhase in
            // Si la fase/estado cambia a background, bloquea el contenido
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
```

Este código muestra una estructura de SwiftUI llamada `LockScreenView` que puede ser utilizada para mostrar contenido en una aplicación con una pantalla de bloqueo. La estructura toma un parámetro genérico `Content` que debe ser una vista de SwiftUI.

La estructura tiene un estado `isUnlocked` que indica si el contenido está desbloqueado o no. También tiene una propiedad `scenePhase` que se utiliza para escuchar el cambio de estado de la escena de la aplicación.

La estructura tiene un inicializador que toma una función de construcción de vista que se utiliza para crear el contenido a mostrar. En el cuerpo de la estructura. La vista de desbloqueo llama al método `authenticateWithBiometrics` para autenticar al usuario.

El método `authenticateWithBiometrics` llama al servicio de autenticación local para autenticar al usuario con biometría. Si la autenticación es exitosa, se cambia el estado `isUnlocked` a verdadero para desbloquear el contenido. Si falla, se imprime el mensaje de error.

El cuerpo de la estructura también tiene un listener para el cambio de estado de escena. Si el estado cambia a background, el contenido se bloquea cambiando el estado `isUnlocked` a falso. Esto es importante si queremos proteger la información después de que la aplicación pase a background.

## Ejemplo

Por último, veamos lo sencillo que es usar la vista `LockScreenView`:

```swift
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
```

Dentro de la estructura `LockScreenView` se encuentra el contenido real de la aplicación, en este caso un `VStack` que contiene una imagen y un texto.

## Conclusión

En resumen, en este tutorial hemos aprendido cómo utilizar la funcionalidad de autenticación biométrica en una aplicación de SwiftUI. Hemos visto cómo crear una clase de servicio de autenticación local que utiliza LAContext para autenticar al usuario con su huella dactilar o rostro. También hemos visto cómo utilizar esta clase de servicio en una vista personalizada de pantalla de bloqueo llamada `LockScreenView` para proteger el contenido de la aplicación. Finalmente, hemos visto cómo utilizar `LockScreenView` para proteger el contenido de la aplicación en la vista principal.

Espero que este tutorial le haya proporcionado una mejor comprensión de cómo utilizar la funcionalidad de autenticación biométrica en sus aplicaciones de SwiftUI. Recuerde que esta es solo una forma de implementar esta funcionalidad, y hay muchas otras formas de proteger el contenido de su aplicación. Siempre es importante evaluar las necesidades de seguridad de su aplicación y elegir la mejor solución para su caso de uso específico.