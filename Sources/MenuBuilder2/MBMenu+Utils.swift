//
//  MBMenu+Utils.swift
//  
//
//  Created by Kai Shao on 2023/1/6.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension MBMenu {
    struct Action: Hashable {
        static func == (lhs: MBMenu.Action, rhs: MBMenu.Action) -> Bool {
            true
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine("MBMenu.hash")
        }
        
        var action: @MainActor () async -> Bool?
    }
}

extension Array: MBMenuConvertible where Element == MBMenu {
    public var anyMenus: [MBMenu] {
        self
    }
}

#if os(iOS)
public extension MBMenu {
    func image(_ image: PlatformImage?) -> Self {
        var me = self
        me.image = image
        return me
    }
    
    func attributes(_ attributes: UIMenuElement.Attributes = []) -> Self {
        var me = self
        me.atrributes = attributes
        return me
    }
    
    func menuOptions(_ options: UIMenu.Options = []) -> Self {
        var me = self
        me.menuOptions = options
        return me
    }
    
    func checked(_ isTrue: Bool = true) -> Self {
        var me = self
        me.checked = isTrue
        return me
    }
    
    func color(_ color: PlatformColor?) -> Self {
        var me = self
        me.color = color
        return me
    }
    
    func subtitle(_ subtitle: String?) -> Self {
        var me = self
        me.subtitle = subtitle
        return me
    }
}
#endif

#if os(iOS)
public typealias PlatformImage = UIImage
public typealias PlatformColor = UIColor
extension UIMenuElement.Attributes: Hashable {}
extension UIMenu.Options: Hashable {}
#else
public typealias PlatformImage = NSIMage
public typealias PlatformColor = NSColor
#endif
