codificationStandard.md

# Estándar de codificación

En éste archivo se pueden ver los estándares de codificación que **Olimpo** usará para programar en los siguientes lenguajes:
 - [Todos los lenguajes](#general)
     - [Formato y espaciado](#formato-y-espaciado)
     - [Llaves](#llaves)
     - [Comentarios](#comentarios)
     - [Nombres e identificadores](#nombres-e-identificadores)
     - [Declaraciones de control](#declaraciones-de-control)
 - [Swift](#exclusivos-swift)
     - [Funciones](#funciones)
     - [Estilo](#estilo)
     - [Buenas prácticas](#buenas-prácticas)

Éstos estándares están basados de manera parcial en:
 - [Estándar de Airbnb para Swift](https://github.com/airbnb/swift)

## General:
 > [!NOTE]
 > En este apartado se usará JavaScript como ejemplo en los bloques de código

 - [Formato y espaciado](#formato-y-espaciado)
 - [Llaves](#llaves)
 - [Comentarios](#comentarios)
 - [Nombres e identificadores](#nombres-e-identificadores)
 - [Declaraciones de control](#declaraciones-de-control)

### Formato y espaciado:
 - Utilizar 4 espacios por cada tabulación.
    ```js
    // mal
    if (isTrue()) {
    if (isTrue()) {
        if (isTrue()) {
            // ...
        }
    }
    }

    // bien
    if (isTrue()) {
        if (isTrue()) {
            if (isTrue()) {
                // ...
            }
        }
    }
    ```

 - Al asignarle un valor a una variable o usar operadores en general, separar con espacios cada valor y operador.
    ```js
    // mal
    let sum=10+20+30

    // mal
    let sum = 10+20+30

    // bien
    let sum = 10 + 20 + 30
    ```

 - Dejar una línea en blanco al término de cada bloque.
    ```js
    // mal
    if (isTrue()) {
        // ...
    }
    if (isFalse()) {
        // ...
    }

    // bien
    if (isTrue()) {
        // ...
    }

    if (isFalse()) {
        // ...
    }
    ```

 - Si al declarar una función se ocupan muchos parámetros y se vuelve imposible que todo esté en una sola línea, declarar cada parámetro en su propia línea.
    ```js
    // mal
    function processData(let variable1, let variable2, let variable3, let variable4, let variable5, let variable6) {
        // ...
    }

    // bien
    function processData(
        let variable1,
        let variable2,
        let variable3,
        let variable4,
        let variable5,
        let variable6
    ) {
        // ...
    }
    ```

 - Si el lenguaje no lo necesita, no usar `;`.


### Llaves:
 - Para expresiones if y when, siempre usar llaves, aunque solo tengan una línea (a excepción que sea un operador ternario):
    ```js
    // mal
    if (value > 10) value = 0

    // bien
    if (value > 10) {
        value = 0
    }
    ```


 - Seguir el estilo de llaves de _Kernighan y Ritchie_ para bloques con llaves (a excepción que sea un operador ternario).
     - Sin salto de línea antes de la llave de apertura.
     - Salto de línea después de la llave de apertura.
     - Salto de línea antes de la llave de cierre.
     - Salto de línea después de la llave de cierre (solo si esa llave termina, en caso contrario un espacio).

    ```js
    // mal
    if (value > 10)
    {
        // ...
    }
    else
    {
        // ...
    }

    // bien
    if (value > 10) {
        // ...
    } else {
        // ...
    }
    ```


### Declaraciones de control:
 - Separar los paréntesis de la palabra reservada y las llaves con espacio.
    ```js
    // mal
    if(isTrue()){
        // ...
    }

    // bien
    if (isTrue()) {
        // ...
    }
    ```

 - Separar cada condición con espacios.
    ```js
    // mal
    if (isTrue()&&isTrueAgain()) {
        // ...
    }

    // bien
    if (isTrue() && isTrueAgain()) {
        // ...
    }
    ```

 - Si tus declaraciones de control terminan siendo muy largas, separar en varias líneas, y asegurar de que inicien con su operador lógico; e iniciar las declaraciones en una línea extra.
    ```js
    // mal
    if ( firstCond() && secondCond() && thirdCond() ) {
        // ...
    }

    // mal
    if ( 
        firstCond() && 
        secondCond() && 
        thirdCond() 
    ) {
        // ...
    }

    // mal
    if ( firstCond() 
        && secondCond() 
        && thirdCond() ) {
        // ...
    }

    // bien
    if ( 
        firstCond() 
        && secondCond() 
        && thirdCond() 
    ) {
        // ...
    }
    ```


### Comentarios:
 - Si el comentario es de varias líneas, usar el comentario multilinea de dicho lenguaje.
    ```js
    // mal
    // Voy a hacer varios comentarios
    // Comentario 1
    // Comentario 2

    // bien
    /**
     * Voy a hacer varios comentarios
     * Comentario 1
     * Comentario 2
    */
    ```

 - Iniciar cada comentario con un espacio para que sea fácil de leer.
    ```js
    // mal
    //esto es mi comentario

    // bien
    // esto es mi comentario
    ```

 - Para comentarios de una sola línea poner una línea vacía antes del comentario a menos de que sea la primer línea del bloque, o que se estén encadenando funciones, en cuyo caso sí se puede comentar sobre la misma línea.
    ```js
    // mal
    if (isTrue) {

        // Significa que es verdadero
        const zero = 0
        // Le pongo un valor
        const one = 1
    }

    // mal
    if (isTrue) {

        // Significa que es verdadero
        const zero = 0
        
        // Le pongo un valor
        const one = 1
    }

    // bien
    if (isTrue) {
        // Significa que es verdadero
        const zero = 0

        // Le pongo un valor
        const one = 1
    }

    // bien
    funcionA // Comentario sobre la línea
    .funcionB // Comentario sobre la línea
    .funcionC // Comentario sobre la línea
    ```

### Nombres e identificadores:
 - Usar `SCREAMING_SNAKE_CASE` para nombrar constantes.
    ```js
    // mal
    const pi = 3.14
    const ourName = "Olimpo"

    // bien
    const PI = 3.14
    const OUR_NAME = "Olimpo"
    ```

 - Usar `PascalCase` para nombrar clases, estructuras, interfaces, protocolos, enum o tipos.
    ```js
    // mal
    class mountOlympus {
        // ...
    }

    // bien
    class MountOlympus {
        // ...
    }
    ```

 - Usar `camelCase` para nombrar métodos y variables.
    ```js
    // mal
    let FreeDay = "Wednesay"

    // bien
    let freeDay = "Wednesday"
    ```

 - Ser descriptivo con los nombres que hagas.
    ```js
    // mal
    let x = 5

    // bien
    let teamAmount = 5
    ```

 - Si usas un booleano, asegegurar de incluir una palabra como `is` o `has` para denotar que es un predicado.
    ```js
    // mal
    let active = true

    // bien
    let isActive = true
    ```

 - En lenguajes tipados, siempre especificar de forma explícita el tipo de cada variable.
    ```kotlin
    // Ejemplo en Kotlin

    // mal
    var ourName = "Olimpo"

    // bien
    val ourName: String = "Olimpo"
    ```


### Strings:
 - Usar comillas dobles `" "`, salvo de que la situación no lo permita.
    ```js
    // mal
    const ourName = 'Olimpo'

    // bien
    const ourName = "Olimpo"
    ```

 - Usar string multilinea solo en caso de que sea estrictamente necesario.
    ```js
    // mal (string corto innecesariamente en multilínea)
    const greeting = `
    Hola
    Olimpo
    `;

    // mal (string de una sola línea)
    const message = `Nothing.`

    // bien (string extenso donde mejora la legibilidad)
    const errorMessage = `
    Error: No se pudo conectar con el servidor.
    Posibles causas:
    - La red no está disponible.
    - El servidor no responde.
    - La configuración es incorrecta.
    `;
    ```

## Exclusivos Swift:
 - [Funciones](#funciones-1)
 - [Estilo](#estilo)
 - [Buenas prácticas](#buenas-prácticas)

### Estilo:
 - Evitar `self` salvo que sea necesario.
    ```swift
    // mal
    class Planet {
        var name: String
        
        init(name: String) {
            self.name = name
        }
        
        func printName() {
            self.name = "Earth"
            print(self.name)
        }
    }

    // bien
    class Planet {
        var name: String
        
        init(name: String) {
            self.name = name
        }
        
        func printName() {
            name = "Earth" // self innecesario
            print(name)
        }
    }
    ```

 - No usar espacios dentro de colecciones.
    ```swift
    // mal
    let planets = [ "Mercury" , "Venus","Earth", "Mars" ]

    // bien
    let planets = ["Mercury", "Venus", "Earth", "Mars"]
    ```

 - Preferir bucles for envés de forEach salvo que sea funcionalidad final.
    ```swift
    // mal
    planets.forEach {
        print($0)
    }

    // bien
    for planet in planets {
        print(planet)
    }
    ```

### Buenas prácticas:
 - Inicializar propiedades en `init` siempre que sea posible.
    ```swift
    // mal
    class User {
        var name: String
        var age: Int?
        
        init() {
        }
    }

    // bien
    final class User {
        let name: String
        let age: Int?
        
        init(name: String, age: Int? = nil) {
            self.name = name
            self.age = age
        }
    }
    ```

 - Usar valores inmutables (`let`) siempre que sea posible.

 - Usar `guard` al inicio de un scope.
    ```swift
    // mal
    func process(value: Int?) {
        if value == nil {
            return
        }
        print(value!)
    }

    // bien
    func process(value: Int?) {
        guard let value else {
            return
            }
        print(value)
    }
    ```


### Funciones:
 - Al usar cadenas de funciones, no dejar líneas vacías entre ellas.

    ```swift
    // mal
    var innerPlanets: [String] {
        planets
            .filter { $0.isInnerPlanet }
            
            .map { $0.name }
    }

    // bien
    var innerPlanets: [String] {
        planets
            .filter { $0.isInnerPlanet }
            .map { $0.name }
    }
    ```
