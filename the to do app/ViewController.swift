//
//  ViewController.swift
//  the to do app
//
//  Created by Azzam R Alrashed on 31/12/2020.
//

import UIKit

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        title = "To do list"
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new items text", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let action = UIAlertAction(title: "Create", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self?.createNewItem(text: text)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    var models = [ToDoItem]()
    func getAllItems() {
        do {
            models = try context.fetch(ToDoItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch  {
            print("error happened when fetching the to do items")
        }
    }
    
    func createNewItem(text: String) {
        let newItem = ToDoItem(context: context)
        newItem.text = text
        newItem.createdAt = Date()
        do {
            try context.save()
            getAllItems()
        } catch {
            print("error happened when creating new item")
        }
    }
    
    func updateItem(item: ToDoItem, newText: String) {
        item.text = newText
        do {
            try context.save()
            getAllItems()
        } catch {
            print("error happened when updating the item")
        }
    }
    
    func deleteItem(item: ToDoItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            print("error happened when deleting the item")
        }
    }
    
    func getHijriCalendarDate(date: Date) -> String {
        let hijriCalendar = Calendar(identifier: .islamicCivil)
        let formater = DateFormatter()
        formater.calendar = hijriCalendar
        formater.dateFormat = "EEE dd MMMM yyyy"
        
        return formater.string(from: date)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = models[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = model.text! + "\n\(getHijriCalendarDate(date: model.createdAt!))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        let alert = UIAlertController(title: "Edit Item", message: "Edit items text", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = model.text
        let action = UIAlertAction(title: "Create", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self?.updateItem(item: model, newText: text)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, view, completionHandler) in
            
            self.deleteItem(item: self.models[indexPath.row])
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = models[indexPath.row]
        if !model.text!.contains("✅") {
            let doneAction = UIContextualAction(style: .normal, title: "done") { (action, view, completionHandler) in
                
                self.updateItem(item: model, newText: "✅ \(model.text!)")
            }
            
            return UISwipeActionsConfiguration(actions: [doneAction])
        }
        return nil
    }
    
}

