//
//  Getter.swift
//  Nuclear
//
//  Created by Josiah Gaskin on 5/4/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

let IDENTITY = {(args: [Immutable.State]) -> Immutable.State in
    return args[0]
}

public class Getter : Hashable, Equatable {
    private static let tagger = Tag()
    let keyPath : [AnyObject]
    let compute : ([Immutable.State]) -> Immutable.State
    private var id : UInt
    
    init (keyPath: [AnyObject]) {
        self.keyPath = keyPath
        self.compute = IDENTITY
        self.id = 0
    }
    
    init (keyPath: [AnyObject], withFunc: ([Immutable.State]) -> Immutable.State) {
        self.keyPath = keyPath
        self.compute = withFunc
        self.id = Getter.tagger.nextTag()
    }
    
    // Adaptation of djb2
    public var hashValue : Int {
        var hash = 5381 * 33 + Int(self.id)
        for key in self.keyPath {
            hash = ((hash << 5) + hash) + (key.hashValue ?? 33)
        }
        return hash
    }
    
    public var name : String {
        return "Getter\(self.hashValue)"
    }
    
    public var nameForNSNotification : String {
         return "\(self.name)HasChanged"
    }
    
    public var keysOnly : Getter {
        return Getter(keyPath: Evaluator.keyPathParts(self))
    }
    
    public var recursives : [Getter] {
        return Evaluator.recursiveParts(self)
    }
    
    public func extendKeyPath(keyPath: [AnyObject]) -> Getter {
        var totalKeyPath = self.keyPath
        totalKeyPath.extend(keyPath)
        return Getter(keyPath: totalKeyPath, withFunc: self.compute)
    }
}

public func ==(a: Getter, b: Getter) -> Bool {
    if a.keyPath.count != b.keyPath.count {
        return false
    }
    for var i = 0; i < a.keyPath.count; i++ {
        if let ai = a.keyPath[i] as? String, let bi = b.keyPath[i] as? String {
            if ai != bi { return false }
        } else if let ai = a.keyPath[i] as? Int, let bi = b.keyPath[i] as? Int {
            if ai != bi { return false }
        }  else if let ai = a.keyPath[i] as? Getter, let bi = b.keyPath[i] as? Getter {
            if ai != bi { return false }
        }
    }
    return true
}

public func !=(a: Getter, b: Getter) -> Bool {
    return !(a == b)
}
