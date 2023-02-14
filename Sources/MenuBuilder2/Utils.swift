//
//  Utils.swift
//  
//
//  Created by Kai Shao on 2023/1/6.
//

import Foundation

extension String {
    var loc: Self {
        String(format: NSLocalizedString(self, bundle: .module, comment: ""), "")
    }
    
    func loc(_ string: String) -> Self {
        String(format: NSLocalizedString(self, comment: ""), string)
    }
}
