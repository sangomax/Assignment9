//
//  Task.swift
//  Assignment6
//
//  Created by Adriano Gaiotto de Oliveira on 2021-01-08.
//

import Foundation

//struct Tasks {
//    let tasks : [Task]
//}

struct Task : Codable{
    var id: Int64
    var noChecked: Bool
    var name: String
    var desc: String
    var priority: String
    
    init(lName: String, lDesc: String, lPrio: String) {
        id = 0
        noChecked = true
        name = lName
        desc = lDesc
        priority = lPrio
    }
    
    init(lId: Int64, lName: String, lDesc: String, lPrio: String) {
        id = lId
        noChecked = true
        name = lName
        desc = lDesc
        priority = lPrio
    }
}


extension Task: Hashable{}

