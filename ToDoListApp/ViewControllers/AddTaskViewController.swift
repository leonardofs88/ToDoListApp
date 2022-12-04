//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by Leonardo Soares on 01/12/22.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    fileprivate let taskSubject: PublishSubject<Task> = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func save() {
        guard let priority = Priority(rawValue: self.segmentedControll.selectedSegmentIndex),
                  let title = taskTextField.text else { return }
        
        let newTask: Task = Task(title: title, priority: priority)
        
        taskSubject.onNext(newTask)
        self.dismiss(animated: true)
    }
}
