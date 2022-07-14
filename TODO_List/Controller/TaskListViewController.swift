//
//  TaskListViewController.swift
//  TODO_List
//
//  Created by Flow_RyanChou on 2022/7/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
//    private var tasks = Variable<[Task]>([])
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    let disposedBag = DisposeBag()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addTVC = navC.viewControllers.first as? AddTaskViewController
        else {
            fatalError("Controller not found")
        }
        
        addTVC.taskSubjectObservable
            .subscribe(onNext:{[unowned self] task in
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
//                self.tasks.value.append(task)
                self.tasks.accept(existingTasks)
                
                self.filterTasks(by: priority)
                
            })
            .disposed(by: disposedBag)
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
        
    }
    
    private func updateTableView() {
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?){
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        }
        else{
            self.tasks
                .map { task in
                    return task.filter { $0.priority == priority! }
                }
                .subscribe(onNext: { [weak self] tasks in
                    self?.filteredTasks = tasks
                    self?.updateTableView()
                })
                .disposed(by: disposedBag)
        }
        
    }
    
}
