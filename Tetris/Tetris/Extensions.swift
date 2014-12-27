//
//  Extensions.swift
//  Tetris
//
//  Created by Ilija Tovilo on 26/12/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

extension Array {
    
    func indexOfElement<U: Equatable>(element: U) -> Int? {
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if element == to {
                    return idx
                }
            }
        }
        
        return nil
    }

    mutating func removeElement<U: Equatable>(element: U) {
        if let index = indexOfElement(element) {
            self.removeAtIndex(index)
        }
    }
    
}
