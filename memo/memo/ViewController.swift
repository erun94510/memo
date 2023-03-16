//
//  ViewController.swift
//  memo
//
//  Created by Donghoon Bae on 2023/03/08.
//

import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memoList: [NSManagedObject] {
        return try! readMemoData()
    }
    
    var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToCreateMemoView(_:)))
        let memoTitle = "Memo"
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = memoTitle
        
        
    }
    
    

}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        
        let row = self.memoList[indexPath.row]
        let content = row.value(forKey: "content") as? String
        let createdOrEditAtDate = row.value(forKey: "createdOrEditAtDate") as? Date
        
        cell.textLabel?.text = content
        cell.detailTextLabel?.text = "\(String(describing: createdOrEditAtDate))"
        return cell
    }
    
    @objc private func moveToCreateMemoView(_ sender: Any) {
        let vc = CreateMemoView()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func createMemoData(content: String, createdOrEditAtDate: Date) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Memo", in: managedContext)!
        
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(UUID(), forKey: "id")
        object.setValue(content, forKey: "content")
        object.setValue(createdOrEditAtDate, forKey: "createdOrEditAtDate")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print(#function, "Can't create Memo : \(error)")
            return false
        }
    }
    
    func readMemoData() throws -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        
        do {
            let resultList = try managedContext.fetch(fetchRequest)
            return resultList
        } catch let error as NSError {
            print(#function, "Can't read Memo : \(error)")
            throw error
        }
    }
    
    func updateMemoData(object: NSManagedObject, content: String, createdOrEditAtDate: Date) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            object.setValue(content, forKey: "content")
            object.setValue(createdOrEditAtDate, forKey: "createdOrEditAtDate")
            
            try managedContext.save()
            return true
        } catch let error as NSError {
            print(#function, "Can't update Memo : \(error)")
            return false
        }
    }
    
    func deleteMemoData(object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(object)
            do {
                try managedContext.save()
                return true
            } catch let error as NSError {
                print(#function, "Can't delete Memo : \(error)")
                return false
            }
    }
}

