//
//  Queue.swift
//  AlertQueue-Example
//
//  Created by William Boles on 08/06/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation

struct Queue<Element> {
    private var elements = [Element]()
    
    // MARK: - Operations
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.removeFirst()
    }
}
