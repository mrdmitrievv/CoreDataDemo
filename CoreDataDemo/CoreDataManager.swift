import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()        
            
    func getUpdatedTasksList(add taskName: String, to tasks: [Task], inContext context: NSManagedObjectContext, completion: @escaping([Task]) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        var updatedTasks: [Task] = []
        updatedTasks = tasks
        
        task.name = taskName
        updatedTasks.append(task)
        
//        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
//        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        
        completion(updatedTasks)
    }
    
    func deleteTask(inContext context: NSManagedObjectContext, fromTasksList tasks: [Task], withIndexPath indexPath: IndexPath) {
        context.delete(tasks[indexPath.row])
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}
