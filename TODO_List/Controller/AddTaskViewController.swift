//
//  AddTaskViewController.swift
//  TODO_List
//
//  Created by Flow_RyanChou on 2022/7/12.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var prioritySegementedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.prioritySegementedControl.selectedSegmentIndex),
              let title = self.taskTitleTextField.text
        else { return }
                    
        let task = Task(title: title, priority: priority)
        
    }
    
}
