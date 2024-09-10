//
//  File.swift
//  
//
//  Created by Diederick de Buck on 10/09/2024.
//

public enum MetaState {
    case confirmed
    case nowait
}

public class Meta {
    public var resources: Int
    public var confirmedCount: Int
    public var nowaitCount: Int
    
    public var isCompleted: Bool {
        nowaitCount == 0
    }
    
    public init(_ resources: Int) {
        self.resources = resources
        self.nowaitCount = 0
        self.confirmedCount = 0
    }
    
    public func rearm() {
        self.nowaitCount = self.resources
        self.confirmedCount = self.resources
    }
    
    public func vsem(_ metaState: MetaState) {
        switch metaState {
        case .confirmed:
            if self.confirmedCount > 0 {
                self.confirmedCount -= 1
            }
        case .nowait:
            if self.nowaitCount > 0 {
                self.nowaitCount -= 1
            }
        }
    }
}
