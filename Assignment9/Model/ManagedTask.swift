//
//  ManagedTask.swift
//  Assignment9
//
//  Created by Adriano Gaiotto de Oliveira on 2021-02-19.
//

import UIKit
import CoreData

class ManagedTask: NSManagedObject {
    class func findOrCreateTask(matching taskInfo: Task, in context: NSManagedObjectContext) throws -> ManagedTask {
     
      let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
        request.predicate = NSPredicate(format: "taskId = %@", NSNumber(value: taskInfo.id))
      do {
        let matches = try context.fetch(request)
        if matches.count > 0 {
          assert(matches.count == 1, "ManagedTask.findOrCreateTask -- database inconsistency")
          let matchedTask = matches[0]
            print(matchedTask)
            matchedTask.taskName = taskInfo.name
            matchedTask.taskDescription = taskInfo.desc
            matchedTask.taskPriority = taskInfo.priority
          return matchedTask
        }
      } catch {
        throw error
      }
      
      // no match
        
    
      let task = ManagedTask(context: context)
        task.taskId = taskInfo.id
        task.taskName = taskInfo.name
        task.taskDescription = taskInfo.desc
        task.taskPriority = taskInfo.priority
        task.noSelected = taskInfo.noChecked
      return task
    }
}
