//
//  Router.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 13/4/24.
//

import SwiftUI

protocol RouterDelegate {
    associatedtype Route = Path
    func pushView(_ newView: Route)
    func popToRoot()
    func pop()
    func popUntil(_ targetRoute: Route)
}

class Router: ObservableObject, RouterDelegate {
    @Environment(\.presentationMode) var presentationMode
    
    @Published var navStack: [Paths] = []
    
    func pushView(_ newView: Paths) {
        navStack.append(newView)
    }
    
    func popToRoot() {
        navStack.removeAll()
    }
    
    func pop() {
        if !navStack.isEmpty {
            navStack.removeLast()
        }
    }
    
    func popUntil(_ targetRoute: Paths) {
        if !navStack.isEmpty {
            navStack.removeLast()
        }
    }
}

extension Router {
    enum Paths: Equatable, CaseIterable {
        static var allCases: [Router.Paths] = [.homePage]
        case homePage
        case custom(view: AnyView)
    }
    
    enum Routes {
        static let routes: [Paths: AnyView] = [
            .homePage: AnyView(HomePage(viewModel: HomePageViewModel()))
        ]
    }
    
    static func getRoute(for path: Paths) -> AnyView {
        switch path {
        case .homePage:
            return AnyView(HomePage(viewModel: HomePageViewModel()))
        case .custom(let view):
            return view
        }
    }
}

extension View {
    func pushPath() -> some View {
        self.navigationDestination(for: Router.Paths.self) { path in
            Router.getRoute(for: path)
        }
    }
}

extension Router.Paths: Hashable {
    static func == (lhs: Router.Paths, rhs: Router.Paths) -> Bool {
        switch (lhs, rhs) {
        case (.homePage, .homePage):
            return true
        case (.custom, .custom):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .homePage:
            hasher.combine("homePage")
        case .custom(_):
            hasher.combine("custom")
        }
    }
}

/*
 
 //
 //  Router.swift
 //  RickAndMortyApp
 //
 //  Created by Ignacio Lopez Jimenez on 13/4/24.
 //

 import SwiftUI

 // Definición de un protocolo RouterDelegate con métodos para la gestión de vistas en una pila de navegación.
 protocol RouterDelegate {
     // Tipo asociado que define el tipo de ruta o vista que se manejará. Por defecto es 'Path', pero será sobreescrito más adelante.
     associatedtype Route = Path
     func pushView(_ newView: Route) // Método para añadir una vista a la pila
     func popToRoot() // Método para volver a la vista raíz, limpiando la pila
     func pop() // Método para eliminar la última vista de la pila
     func popUntil(_ targetRoute: Route) // Método para retroceder en la pila hasta una vista específica
 }

 // Clase Router que implementa el protocolo RouterDelegate y se observa para cambios en sus propiedades.
 class Router: ObservableObject, RouterDelegate {
     @Environment(\.presentationMode) var presentationMode // Usado para acceder al modo de presentación actual en SwiftUI
     
     // Pila de navegación que contiene las rutas actuales
     @Published var navStack: [Paths] = []
     
     // Método para añadir una nueva ruta a la pila
     func pushView(_ newView: Paths) {
         navStack.append(newView)
     }
     
     // Método para vaciar la pila y volver a la vista raíz
     func popToRoot() {
         navStack.removeAll()
     }
     
     // Método para eliminar la última ruta de la pila
     func pop() {
         if !navStack.isEmpty {
             navStack.removeLast()
         }
     }
     
     // Método para eliminar rutas de la pila hasta llegar a una ruta específica (pero este método necesita implementación para verificar contra targetRoute)
     func popUntil(_ targetRoute: Paths) {
         while navStack.last != targetRoute && !navStack.isEmpty {
             navStack.removeLast()
         }
     }
 }

 // Extensión de Router para definir las rutas posibles y cómo obtener las vistas asociadas.
 extension Router {
     // Enumeración que define los tipos de ruta que se pueden manejar.
     enum Paths: Equatable, CaseIterable {
         static var allCases: [Router.Paths] = [.homePage] // Casos disponibles de rutas
         case homePage // Una ruta simple
         case custom(view: AnyView) // Una ruta que permite una vista personalizada
     }
     
     // Diccionario para mapear rutas a vistas específicas
     enum Routes {
         static let routes: [Paths: AnyView] = [
             .homePage: AnyView(HomePage(viewModel: HomePageViewModel())) // Mapea la ruta 'homePage' a la vista 'HomePage'
         ]
     }
     
     // Función para obtener la vista correspondiente a una ruta dada
     static func getRoute(for path: Paths) -> AnyView {
         switch path {
         case .homePage:
             return AnyView(HomePage(viewModel: HomePageViewModel()))
         case .custom(let view):
             return view
         }
     }
 }

 // Extensión de View para facilitar la navegación basada en rutas.
 extension View {
     // Método que configura la navegación basada en rutas
     func pushPath() -> some View {
         self.navigationDestination(for: Router.Paths.self) { path in
             Router.getRoute(for: path) // Obtiene y muestra la vista correspondiente a la ruta
         }
     }
 }

 // Conformidad de Router.Paths con Hashable para su uso en colecciones que requieren unicidad
 extension Router.Paths: Hashable {
     static func == (lhs: Router.Paths, rhs: Router.Paths) -> Bool {
         switch (lhs, rhs) {
         case (.homePage, .homePage), (.custom, .custom):
             return true
         default:
             return false
         }
     }
     
     func hash(into hasher: inout Hasher) {
         switch self {
         case .homePage:
             hasher.combine("homePage")
         case .custom(_):
             hasher.combine("custom")
         }
     }
 }


 
 */
