//
//  CustomInject.swift
//  Domain
//
//  Created by thanos kottaridis on 28/1/23.
//

import Foundation

/**
    Custom Dependency Injection Implementation inspired from @Environment property wrapper in SwiftUI.
    - This Implementation Uses swift property Wrapper and Subscript type.
    - The final implementation will use a propertyWrapper takes a key path reference and creates a val pointing to the injecting value.
    **@Injected(key path )**
    - All Injected references Point to the same Injected Instance (so changing InjectedValues of one property also affects already injected properties)
 
    # PropertyWrapper:
    Is a wrapper of a value that run a specific code/logic every time that wrappedProperty gets or sets. The only requirement is to contain a weappedValue property.
 
    # Subscript Syntax:
    What is subscript and how it works? Like dictionary can implement the following format in order to return a value by key
    **collection[key] = ···**
    Subscript syntax allows us to implement custom functions (logic) that runs on Collections dictionaries and strings.
 
    ###Docs:
    Dependency Injection: https://www.avanderlee.com/swift/dependency-injection/
    Property Wrapper: https://www.swiftbysundell.com/articles/property-wrappers-in-swift/
    Subscript Syntax: https://learnappmaking.com/subscript-syntax-swift/
    
 */

public protocol InjectionKey {
    
    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value
    
    /// default value for Dependency Injection key
    static var currentValue: Self.Value {get set}
}

/// Provides access to injected dependencies.
public struct InjectedValues {
    
    /// This current object holds all injected values across the app
    private static var current = InjectedValues()
    
    /**
     This static Subscript is used in order to update Current Value of InjectionKey instance.
     Takes as argument the K type where K must Conform InjectionKey protocol
     (usage example: **InjectedValues[K.self]**)
     */
    public static subscript<K>(key: K.Type)-> K.Value where K: InjectionKey {
        get{key.currentValue}
        set{key.currentValue = newValue}
    }
    
    /**
        This static subscript is used in order to reference and update dependencies directly.
        Takes as argument a Mutable KeyPath of InjectedValue property (One of providers created in extension)
        an a type of Provider <T>
     */
    public static subscript<T>(keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get {current[keyPath: keyPath]}
        set {current[keyPath: keyPath] = newValue}
    }
}

/**
    This property Wrapper is used in order To inject values using the annotation `@Injected`
    The property wrapper works closely together with the `InjectedValues` struct:
 
    **Usage Example:** In order to inject NetworkProvider we use
    @Injected(/.networkProvider) (the name of var in extension)
 */
@propertyWrapper
public struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    public var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    public init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}
