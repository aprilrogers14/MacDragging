//
//  TextDropDelegate.swift
//  MacDragging
//
//  Created by April Rogers-Kent on 8/21/24.
//

import SwiftUI

struct TextDropDelegate: DropDelegate {
    @Binding var count: Int
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if info.hasItemsConforming(to: [.text]) {
            return .init(operation: .copy)
        }
        
        return .init(operation: .forbidden)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if info.hasItemsConforming(to: [.text]) {
            count += 1
            return true
        }
        
        return false
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [.text])
    }
}
