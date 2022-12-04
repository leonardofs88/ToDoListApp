//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Leonardo Soares on 27/11/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var disposeBag: DisposeBag = DisposeBag()
    
    fileprivate var tasks: BehaviorRelay<[Task]> = BehaviorRelay<[Task]>(value: [])
    fileprivate var filteredTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController,
              let addTaskViewController = navigation.viewControllers.first as? AddTaskViewController
        else { fatalError("Controller not found") }
        
        addTaskViewController.taskSubjectObservable
            .subscribe( onNext: { [weak self] task in
                guard let self = self else { return }
                
                let priority: Priority? = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var currentTasks: [Task] = self.tasks.value
                currentTasks.append(task)
                self.tasks.accept(currentTasks)
                self.filter(by: priority)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func valueChanged(segmentedControl: UISegmentedControl) {
        let priority: Priority? = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        self.filter(by: priority)
    }
    
    fileprivate func filter(by priority: Priority?) {
        guard let priority = priority else {
            self.filteredTasks = self.tasks.value
            self.tableView.reloadData()
            return
        }
        
        self.tasks.map { tasks in
            return tasks.filter { $0.priority == priority }
        }
        .subscribe( onNext: { [weak self] tasksByPriority in
            self?.filteredTasks = tasksByPriority
            self?.tableView.reloadData()
            print(tasksByPriority)
        })
        .disposed(by: disposeBag)
    }
    
}

extension TaskListViewController: UITableViewDelegate {
    
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
}
