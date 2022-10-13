//
//  NotesController.swift
//  TodoListUsingCoreData
//
//  Created by Ashok Kanigiri on 11/10/22.
//

import Foundation
import UIKit
import CoreData

class NotesController : UIViewController  {
    
    
    @IBOutlet weak var notesTableView: UITableView!
    
    @IBAction func addNotesClickHandler(_ sender: UIBarButtonItem) {
        populateDialog(title: "Add New Notes", showTextField: true, bottomButtonTitle: "Add")
    }
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notesList = [Notes]()
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        registerTableviewCell()
        initViewcontroller()
    }
    
    func registerTableviewCell(){
        notesTableView.register(UINib(nibName: "NotestItemView", bundle: nil), forCellReuseIdentifier: "notesItemView")
    }
    
    func initViewcontroller(){
        notesTableView.dataSource = self
        navigationItem.title = selectedCategory?.categoryName
    }
    
    func populateDialog(title: String, showTextField: Bool, bottomButtonTitle: String){
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: bottomButtonTitle, style: .default) { action in
            if(showTextField){
                let noteContent = alertController.textFields?[0].text ?? "NIL"
                self.saveNote(noteContent: noteContent)
            }
        }
        
        if(showTextField){
            alertController.addTextField { textfield in
                
            }
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK : Coredata methods
extension NotesController {
    
    func loadData(){
        let request: NSFetchRequest<Notes>  = Notes.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory?.categoryName ?? "")
        
        request.predicate = predicate
        
        do {
            notesList =  try context.fetch(request)
            notesTableView?.reloadData()
        }catch {
            print("error while loading notes")
        }
    }
    
    func saveNote(noteContent : String){
      
        var note = Notes(context: context)
        note.noteId = UUID.init().uuidString
        note.note = noteContent
        note.parentCategory = selectedCategory
        
        do{
            try context.save()
        }catch {
           print("error while saving note")
        }
        loadData()
    }
}

extension NotesController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesItemView", for: indexPath) as! NotestItemView
        
        cell.notesLabel.text = notesList[indexPath.row].note
        
        return cell
    }
    
    
}
