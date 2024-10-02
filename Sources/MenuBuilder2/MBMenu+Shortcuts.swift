//
//  MBMenu+Shortcuts.swift
//  
//
//  Created by Kai Shao on 2023/1/6.
//
#if canImport(UIKit)
import Foundation

public extension MBMenu {
    static func delete(action: @MainActor @escaping () async -> Bool?) -> MBMenu {
        var menu = MBMenu(title: "action_discard".loc)
            .color(.systemRed)
            .image(.init(systemName: "trash"))
        
        menu.atrributes = .destructive
        menu.actionWrapper.action = {
            await action()
        }
        
        return menu
    }
    
    static func edit(action: @escaping () async -> Void) -> MBMenu {
        .init(title: "action_edit".loc, action: action)
        .color(.systemBlue)
        .image(.init(systemName: "pencil.circle"))
    }
    
    static func detail(_ title: String? = nil, action: @escaping () async -> Void) -> MBMenu {
        .init(title: title ?? "action_detail".loc,
              action: action)
        .image(PlatformImage(systemName: "info.circle"))
    }
    
    static func duplicate(action: @escaping () async -> Void) -> MBMenu {
        .init(title: "action_duplicate".loc, action: action)
        .color(.systemGreen)
        .image(PlatformImage(systemName: "doc.on.doc"))
    }
    
    static func add(action: @escaping () async -> Void) -> MBMenu {
        .init(symbol: "plus.circle", action: action)
    }
    
    static func add(@MenuBuilder children: () -> [MBMenu]) -> MBMenu {
        .init(symbol: "plus.circle", children: children)
    }
    
    static func done(action: @escaping () async -> Void) -> MBMenu {
        .init(systemItem: .done, action: action)
    }
    
    static func cancel(action: @escaping () async -> Void) -> MBMenu {
        .init(systemItem: .cancel, action: action)
    }
    
    static var flexSpace: MBMenu {
        .init(systemItem: .flexibleSpace)
    }
    
    static func more(@MenuBuilder children: () -> [MBMenu]) -> MBMenu {
        .init(title: "action_more".loc, children: children)
        .color(.systemBlue)
        .image(.init(systemName: "ellipsis.circle"))
    }
}
#endif
