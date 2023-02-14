//
//  MenuBuilder.swift
//  
//
//  Created by Kai Shao on 2023/1/5.
//

import Foundation

@resultBuilder
public enum MenuBuilder {
}

public extension MenuBuilder {
    static func buildBlock(_ components: MBMenuConvertible...) -> [MBMenu] {
        components.flatMap(\.anyMenus)
    }
    
    static func buildBlock(_ components: [MBMenuConvertible]) -> [MBMenu] {
        components.flatMap(\.anyMenus)
    }
    
    static func buildOptional(_ component: [MBMenuConvertible]?) -> [MBMenu] {
        component?.flatMap(\.anyMenus) ?? []
    }
    
    static func buildEither(first component: [MBMenuConvertible]) -> [MBMenu] {
        component.flatMap(\.anyMenus)
    }
    
    static func buildEither(second component: [MBMenuConvertible]) -> [MBMenu] {
        component.flatMap(\.anyMenus)
    }
    
    static func buildArray(_ components: [[MBMenuConvertible]]) -> [MBMenu] {
        components.flatMap { $0.flatMap(\.anyMenus) }
    }
}
