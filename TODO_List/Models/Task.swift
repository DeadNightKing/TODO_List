//
//  Task.swift
//  TODO_List
//
//  Created by Flow_RyanChou on 2022/7/12.
//

import Foundation

enum Priority: Int{
    case high
    case medium
    case low
}


struct Task {
    let title: String
    let priority: Priority
}
