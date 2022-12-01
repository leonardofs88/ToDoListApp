//
//  Task.swift
//  ToDoListApp
//
//  Created by Leonardo Soares on 01/12/22.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
