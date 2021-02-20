//
//  TodoTableViewController.swift
//  Assignment6
//
//  Created by Adriano Gaiotto de Oliveira on 2021-01-08.
//

import UIKit
import CoreData

class TodoTableViewController:  UITableViewController, AddEditEmojiTVCDelegate {
    
    let cellId = "TaskCell"
    
    let priorityHeader = ["High Priority", "Medium Priority", "Low Priority"]
    
    let colors = [UIColor.systemRed, UIColor.systemYellow, UIColor.systemGreen]
    
    let initialScreen : UIImageView = {
        var s = UIImageView()
        s.matchParent()
        return s
    } ()
    
    var tasks : [[Task]] = [[],[],[]] 
    
    var cont: Int = 0
    
    fileprivate var indexPathEditing : IndexPath = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.allowsMultipleSelectionDuringEditing = true
        
        navigationItem.title = "Todo Items"
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTask))
        navigationItem.setRightBarButtonItems([addButton, deleteButton], animated: true)
        navigationItem.rightBarButtonItems?[1].isEnabled = false
        
        tasks = ActionsDataBase.shared.loadTasks()
        
        // path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: ", documentsPath)
    }
    
    
    private func navigateToAddEditTVC() {
        let addEditTVC = AddEditTableViewController(style: .grouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }
    
    @objc func addNewTask() {
        navigateToAddEditTVC()
    }
    
    @objc func editTast(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        
        let addEditTVC = AddEditTableViewController(style: .grouped)
        addEditTVC.delegate = self
        addEditTVC.task = tasks[indexPath.section][indexPath.row]
        
        indexPathEditing = indexPath
        
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }
    
    @objc func deleteTask() {
        if let indexPath = tableView.indexPathsForSelectedRows {
            
            for index in indexPath.reversed() {
                ActionsDataBase.shared.updateDatebase(with: tasks[index.section][index.row], action: Action.delete)
                tasks[index.section].remove(at: index.row)
                tableView.deleteRows(at: [index], with: .automatic)
            }
        }
    }
    
    func add(_ task: Task) {
        let priorityCode = Int(task.priority)! - 1
        tasks[priorityCode].append(task)
        tableView.insertRows(at: [IndexPath(row: tasks[priorityCode].count - 1, section: priorityCode)], with: .automatic)
        ActionsDataBase.shared.updateDatebase(with: task, action: Action.insert)
    }
    
    func edit(_ task: Task) {
        
        tasks[indexPathEditing.section].remove(at: indexPathEditing.row)
        tasks[indexPathEditing.section].insert(task, at: indexPathEditing.row)
        tableView.reloadRows(at: [indexPathEditing], with: .automatic)
        indexPathEditing = []
        ActionsDataBase.shared.updateDatebase(with: task, action: Action.update)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.sectionIndexBackgroundColor = colors[section]
        return priorityHeader[section]
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoTableViewCell
        
        cell.editSymbolLabel.addTarget(self, action: #selector(editTast), for: .touchUpInside)
        
        cell.update(with: task)
        cell.showsReorderControl = true
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // update model
        var removedTask = tasks[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        removedTask.priority = String(destinationIndexPath.section + 1)
        tasks[destinationIndexPath.section].insert(removedTask, at: destinationIndexPath.row)
        ActionsDataBase.shared.updateDatebase(with: removedTask, action: Action.update)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if let _ = tableView.indexPathsForSelectedRows {
                navigationItem.rightBarButtonItems?[1].isEnabled = true
            }
            return
        }
        tasks[indexPath.section][indexPath.row].noChecked.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if let _ = tableView.indexPathsForSelectedRows {
                return
            }
            navigationItem.rightBarButtonItems?[1].isEnabled = false
            return
        }
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = colors[section]
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "ChalkboardSE-Bold",size: 20)
    }
    
}
