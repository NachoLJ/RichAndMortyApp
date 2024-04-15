//
//  NSCache.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 12/4/24.
//

import Foundation

protocol NSCacheStoreDataSource {
    // Valores genéricos asociados a este protocolo
    associatedtype Key: Hashable
    associatedtype Value
    
    func save(_ value: Value, forKey key: Key)
    func retrieve(forKey key: Key) -> Value?
    func removeValue(forKey key: Key)
    
    subscript(key: Key) -> Value? { get set }
}

class DefaultNSCacheStoreDataSource <Key: Hashable, Value>: NSCacheStoreDataSource {
    private let wrapped = NSCache<WrappedKey, Entry>()
    
    func save(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }
    
    func retrieve(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    subscript(key: Key) -> Value? {
        get {
            return retrieve(forKey: key)
        }
        set {
            guard let value = newValue else {
                // If nil war assigned using our subscript,
                // then we remove any value for that key
                removeValue(forKey: key)
                return
            }
            save(value, forKey: key)
        }
    }
}

private extension DefaultNSCacheStoreDataSource {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue}
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}

private extension DefaultNSCacheStoreDataSource {
    final class Entry {
        let value: Value
        
        init(value: Value) { self.value = value }
    }
}
