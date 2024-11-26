//
//  AddTaskView.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: TasksViewModel // Access to ViewModel
    @State private var taskName = ""
    @State private var taskDescription = ""

    struct Constants {
        static let navBarTitle = "Add Task"
        static let saveButtonTitle = "Save"
        static let cancelButtonTitle = "Cancel"
        static let formTitle = "Task Details"
        static let taskNamePlaceholder = "Task Name"
        static let taskDescriptionPlaceholder = "Task Description"

    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(Constants.formTitle)) {
                    TextField(Constants.taskNamePlaceholder, text: $taskName)
                    TextField(Constants.taskDescriptionPlaceholder, text: $taskDescription)
                }
            }
            .navigationTitle(Constants.navBarTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveTask) {
                        Text(Constants.saveButtonTitle)
                    }
                    .tint(.indigo)
                    .disabled(taskName.isEmpty || taskDescription.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Constants.cancelButtonTitle) {
                        dismiss()
                    }
                    .tint(.indigo)
                }
            }
        }
    }

    private func saveTask() {
        viewModel.addTask(name: taskName, description: taskDescription)
        dismiss()
    }
}
