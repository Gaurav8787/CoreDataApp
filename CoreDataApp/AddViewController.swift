//
//  AddViewController.swift
//  CoreDataApp
//
//  Created by Gaurav on 14/09/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit
import  CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var txtcityname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.undoManager = UndoManager()
        context.undoManager?.levelsOfUndo = 3
        
        DispatchQueue.main.async {
            
            let newcontext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            newcontext.parent = context
            
            newcontext.perform {
                
                let task = Task(context: newcontext)
                task.cityActive=true
                task.cityName=self.txtcityname.text
                
                do {
                    try newcontext.save()
                    print("after saving into child context")
                    self.getRecords()
                    
                    context.perform{
                        do {
                            try context.save()
                            
                            print("after saving into main context")
                            self.getRecords()
                            
                        } catch{
                            
                        }
                        
                    }
                    
                } catch {
                    
                }
                
                
                
                
            }
            
//
            
            
            
        }
    /*
      
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print("before")
        getRecords()
        
        context.undo()
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print("after undo")
         getRecords()
        
        context.redo()
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print("after redo")
      getRecords()
*/
        
     navigationController?.popViewController(animated: true)

    }
    
    func getRecords() {
        
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            let data = try context.fetch(Task.fetchRequest())
            print(data)
            
        } catch {
            
        }
    }

    @IBAction func searchpreassed(_ sender: UIButton) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchdata = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
      
           // fetchdata.predicate = NSPredicate(format: "cityName == %@",txtcityname.text!)
             fetchdata.predicate = NSPredicate(format: "cityName contains[c] %@",txtcityname.text!)
            let data = try context.fetch(fetchdata) as! [Task]
           

            print(data)
            
        } catch {
            
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
