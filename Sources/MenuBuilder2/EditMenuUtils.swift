//
//  File.swift
//  
//
//  Created by Kai Shao on 2023/1/15.
//

#if canImport(UIKit)
import UIKit

public extension UICollectionView {
    func presentEditMenu(at indexPath: IndexPath, @MenuBuilder menus: () -> [MBMenu]) {
        let cell = cellForItem(at: indexPath)!
        
        if #available(iOS 16, *) {
            let menu = MBMenu.makeUIMenu(menus())
            let interaction: EditMenuInteraction
            
            if let exsitingInteraction = interactions.first(where: { $0 is EditMenuInteraction }) as? EditMenuInteraction {
                interaction = exsitingInteraction
                interaction.menu = menu
            } else {
                interaction = EditMenuInteraction(menu: menu)
                addInteraction(interaction)
            }
            
            let point = cell.convert(.init(x: cell.bounds.midX, y: 0), to: self)
            interaction.present(at: point)
        } else {
            assert(cell.canBecomeFirstResponder)
            let became = cell.becomeFirstResponder()
            assert(became)
            
            UIMenuController.shared.menuItems = menus().map { MenuActionHandler(mbMenu: $0).menuItem }
            UIMenuController.shared.showMenu(from: self, rect: cell.frame)
        }
    }
}

class MenuActionHandler: NSObject {
    let mbMenu: MBMenu
    let menuItem: UIMenuItem
    
    init(mbMenu: MBMenu) {
        self.mbMenu = mbMenu
        self.menuItem = .init(title: mbMenu.title, action: #selector(handler2))
    }
    
    @objc func handler2() {
        print("handler")
        Task {
            await mbMenu.actionWrapper.action()
        }
    }
}

@available(iOS 16.0, *)
class EditMenuInteraction: UIEditMenuInteraction {
    var myDelegate: EditMenuInteractionDelegate?
    var menu: UIMenu
    
    init(menu: UIMenu) {
        let delegate = EditMenuInteractionDelegate()

        self.menu = menu
        self.myDelegate = delegate
        super.init(delegate: delegate)
    }
    
    func present(at point: CGPoint) {
        let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: point)
        presentEditMenu(with: configuration)
    }
    
}

@available(iOS 16.0, *)
class EditMenuInteractionDelegate: NSObject, UIEditMenuInteractionDelegate {
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let interaction = interaction as! EditMenuInteraction
        
        return interaction.menu
    }
}
#endif
