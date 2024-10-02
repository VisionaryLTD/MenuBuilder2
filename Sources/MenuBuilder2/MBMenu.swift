//
//  MBMenu.swift
//  
//
//  Created by Kai Shao on 2023/1/5.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol MBMenuConvertible {
    var anyMenus: [MBMenu] { get }
}

public struct MBMenu: MBMenuConvertible, Hashable {
    public init(title: String = "", image: PlatformImage? = nil, symbol: String? = nil, @MenuBuilder children: () -> [MBMenu]) {
        #if os(iOS)
        let image = image ?? symbol.map { PlatformImage(systemName: $0)! }
        #endif
        
        self.title = title
        self.image = image
        self.actionWrapper = .init { true }
        self.children = children()
    }
    
    public init(title: String = "", image: PlatformImage? = nil, symbol: String? = nil, action: (@MainActor () async -> Void)? = nil) {
        #if os(iOS)
        let image = image ?? symbol.map { PlatformImage(systemName: $0)! }
        #endif
        
        self.title = title
        self.image = image
        self.actionWrapper = .init {
            await action?()
            return true
        }
    }
    
    #if canImport(UIKit)
    public init(systemItem: UIBarButtonItem.SystemItem, @MenuBuilder children: () -> [MBMenu]) {
        self.systemItem = systemItem
        self.actionWrapper = .init { true }
        self.children = children()
    }
    
    public init(systemItem: UIBarButtonItem.SystemItem, action: (@MainActor () async -> Void)? = nil) {
        self.systemItem = systemItem
        self.actionWrapper = .init {
            await action?()
            return true
        }
    }
    #endif
    
    public init(isGroup: Bool = true, @MenuBuilder children: () -> [MBMenu]) {
        self.title = ""
        self.isGroup = isGroup
        self.children = children()
        self.actionWrapper = .init { true }
    }
    
    var title: String = ""
    var color: PlatformColor?
    var subtitle: String?
    var image: PlatformImage?
    #if os(iOS)
    var systemItem: UIBarButtonItem.SystemItem?
    var atrributes: UIMenuElement.Attributes = []
    var menuOptions: UIMenu.Options = []
    var checked: Bool = false
    var barButtonStyle: UIBarButtonItem.Style = .done
    #endif
    var isGroup: Bool = false
    var actionWrapper: MBMenu.Action
    var children: [MBMenu] = []
    
    public var anyMenus: [MBMenu] {
        [self]
    }
}
