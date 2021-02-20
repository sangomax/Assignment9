//
//  ActionsDatabase.swift
//  Assignment9
//
//  Created by Adriano Gaiotto de Oliveira on 2021-02-20.
//

import Foundation
import CoreData

enum Action {
    case update
    case insert
    case delete
    
}

class ActionsDataBase {
    
    static let shared = ActionsDataBase()
    
    var container: NSPersistentContainer = AppDelegate.persistentContainer
    
    func updateDatebase(with task: Task, action: Action) {
        container.performBackgroundTask { (context) in
            // background
            switch action {
            case .insert, .update :
                _ = try? ManagedTask.findOrCreateTask(matching: task, in: context)
            case .delete :
                if let removeTask = try? ManagedTask.findOrCreateTask(matching: task, in: context) {
                    context.delete(removeTask)
                }
            }
            try? context.save()
            print("done loading database...")
            
        }
    }
    
    func loadTasks() -> [[Task]] {
        var tasks : [[Task]] = [[],[],[]]
        let context = container.viewContext
        if let searchTasks = try? context.fetch(ManagedTask.fetchRequest()) as [ManagedTask] {
            for task in searchTasks {
                var newTask = Task(lId: task.taskId, lName: task.taskName!, lDesc: task.taskDescription!, lPrio: task.taskPriority!)
                newTask.noChecked = task.noSelected
                tasks[Int(newTask.priority)!-1].append(newTask)
            }
        }
        return tasks
    }
}
