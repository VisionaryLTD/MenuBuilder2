//
//  UIMenuUtils.swift
//  
//
//  Created by Kai Shao on 2023/1/5.
//

#if canImport(UIKit)
import UIKit
#endif

public extension MBMenu {
    static func makeUIMenu(_ menus: [MBMenu]) -> UIMenu {
        let elements = makeUIMenuRecursively(menus: menus)
        
        return .init(children: elements)
    }
}

private extension MBMenu {
    static func makeUIMenuRecursively(menus: [MBMenu] = []) -> [UIMenuElement] {
        menus.reduce(into: []) { partialResult, item in
            if item.isGroup {
                let menu = UIMenu(options: .displayInline,
                                  children: makeUIMenuRecursively(menus: item.children))
                
                partialResult.append(menu)
            } else if !item.children.isEmpty {
                let menu = UIMenu(title: item.title,
                                  image: item.image,
                                  options: item.menuOptions,
                                  children: makeUIMenuRecursively(menus: item.children))
                
                if #available(iOS 15.0, *) {
                    menu.subtitle = item.subtitle
                }
                
                partialResult.append(menu)
            } else {
                let action = UIAction(title: item.title,
                                      image: item.image,
                                      attributes: item.atrributes,
                                      state: item.checked ? .on : .off) { _ in
                    Task {
                        await item.actionWrapper.action()
                    }
                }
                
                if #available(iOS 15.0, *) {
                    action.subtitle = item.subtitle
                }
                
                partialResult.append(action)
            }
        }
        
    }
}

public extension Array where Element == UIContextualAction {
    static func makeActions(_ menus: [MBMenu]) -> [UIContextualAction] {
        var actions = [UIContextualAction]()
        
        for menu in menus {
            let action = UIContextualAction(style: menu.atrributes.contains(.destructive) ? .destructive : .normal,
                                            title: menu.title) { _, _, completion in
                Task {
                    let result = await menu.actionWrapper.action()
                    
                    DispatchQueue.main.async {
                        completion(result ?? false)
                    }
                }
            }
            
            if let image = menu.image {
                action.image = image
                action.title = nil
            }
            
            if let color = menu.color {
                action.backgroundColor = color
            }
            
            actions.append(action)
        }
        
        return actions
    }
}

extension MBMenu {
    var barButtonItem: UIBarButtonItem {
        if children.isEmpty {
            let action = UIAction { _ in
                Task {
                    await actionWrapper.action()
                }
            }
            
            if let systemItem {
                return .init(systemItem: systemItem, primaryAction: action)
            }
            
            let title = title == "" ? nil : title
            
            return .init(title: title, image: image, primaryAction: action)
        }
        
        let menu = MBMenu.makeUIMenu(children)
        
        if let systemItem {
            return .init(systemItem: systemItem, menu: menu)
        }
        
        return .init(title: title, image: image, menu: menu)
    }
}

public extension UIViewController {
    func setBarButtonItems(left: Bool = false, toolbar: Bool = false, animated: Bool = true, @MenuBuilder menus: () -> [MBMenu]) {
        let items = menus().map { $0.barButtonItem }
        
        if toolbar {
            navigationController?.isToolbarHidden = false
            setToolbarItems(items, animated: animated)
        } else {
            if left {
                navigationItem.setLeftBarButtonItems(items, animated: animated)
            } else {
                navigationItem.setRightBarButtonItems(items, animated: animated)
            }
        }
    }
}

