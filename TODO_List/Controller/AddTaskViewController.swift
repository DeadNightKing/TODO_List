//
//  AddTaskViewController.swift
//  TODO_List
//
//  Created by Flow_RyanChou on 2022/7/12.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>() //發出Task
    
    var taskSubjectObservable: Observable<Task> { //觀測前面發出的Task
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegementedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.prioritySegementedControl.selectedSegmentIndex),
              let title = self.taskTitleTextField.text
        else { return }
                    
        let task = Task(title: title, priority: priority)
        
        taskSubject.onNext(task)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
