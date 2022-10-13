//
//  ViewController.swift
//  TodoListUsingCoreData
//
//  Created by Ashok Kanigiri on 11/10/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var categoryList = [Category]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBAction func addCategoryClickedHandler(_ sender: UIBarButtonItem) {
        populateDialog(title: "Add new category", showTextField: true, bottomButtonTitle: "Add")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(path)
        
        registerTableviewCell()
        
        initViewcontroller()
    }
    
    func registerTableviewCell(){
        categoryTableView.register(UINib(nibName: "CategoryItemView", bundle: nil), forCellReuseIdentifier: "categoryItemView")
    }
    
    func initViewcontroller(){
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        fetchAllCategorys()
    }
    
    func populateDialog(title: String, showTextField: Bool, bottomButtonTitle: String){
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: bottomButtonTitle, style: .default) { action in
            if(showTextField){
                let newCategoryName = alertController.textFields?[0].text ?? "NIL"
                self.insertNewCategory(categoryName: newCategoryName)
            }
        }
        
        if(showTextField){
            alertController.addTextField { textfield in
                
            }
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination as! NotesController
        destinationVc.selectedCategory = categoryList[categoryTableView?.indexPathForSelectedRow?.row ?? 0]
        
    }

}

//MARK: Coredata helper Methods
extension ViewController {
    
    func insertNewCategory(categoryName: String){
        
        let fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName CONTAINS %@", categoryName)
        do {
           let data = try context.fetch(fetchRequest)
            if(data.isEmpty){
                        let category = Category(context: context)
                        category.categoryName = categoryName
                        category.categoryId = UUID.init().uuidString
                        saveContext()
                        fetchAllCategorys()
            }else{
                populateDialog(title: "Category already present in list", showTextField: false, bottomButtonTitle: "dismiss")
            }
        } catch {
            print("Error while insertNewCategory")
        }
        

    }
    
    func fetchAllCategorys(){
        let fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categoryList = try context.fetch(fetchRequest)
        } catch {
            print("Error while fetchAllCategorys")
        }
        categoryTableView.reloadData()
    }
    
    func deleteCategory(category: String){
        let fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName CONTAINS %@", category)
        do {
           let data = try context.fetch(fetchRequest)
            print(data[0])
            context.delete(data[0])
            categoryList.remove(object: data[0])
            saveContext()
            fetchAllCategorys()
        } catch {
            print("Error while deleteCategory")
        }
    }
    
    func saveContext(){
        do {
            try context.save()
        }catch {
            print("Error while saving context")
        }
    }
}

//MARK: Tableview datasource
extension ViewController : UITableViewDataSource , CategoryItemProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemView", for: indexPath) as! CategoryItemView
        
        cell.categoryLabel.text = categoryList[indexPath.row].categoryName
        cell.categoryItemProtocol = self
        
        return cell
    }
    
    func onDeleteButtonClicked(category: String) {
        deleteCategory(category: category)
    }
}

//MARK: Tableview click handler
extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        self.performSegue(withIdentifier: "toNotesList", sender: self)
    }
}



