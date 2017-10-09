//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Gaurav on 14/09/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var tasks = [Task]()
    
    @IBOutlet weak var tableList: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getData()
        tableList.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData()  {
        
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetchr = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            let sort = NSSortDescriptor(key: "cityName", ascending: false)
            fetchr.sortDescriptors = [sort]
            
            tasks = try context.fetch(fetchr) as! [Task]
            
        } catch {
            print("fetching failed")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let tk = tasks[indexPath.row]
        cell.textLabel?.text = tk.cityName
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                tasks = try context.fetch(Task.fetchRequest())
            } catch {
                print("fetching failed")
            }
            
            tableView.reloadData()
            
            
        }
    }
}

