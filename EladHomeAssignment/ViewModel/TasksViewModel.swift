//
//  TasksViewModel.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import Foundation
import Combine
import SwiftUI

final class TasksViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var finishLoading = false
    @Published var tasks: [TaskModel] = []
    @Published private(set) var taskCompletionStateContainer: [Int: Bool] = [:]

    private let completionStateKey = "taskCompletionState"
    private lazy var service = TasksService()
    
    
    // MARK: Method
    
    // Method to load tasks data
    func loadTasks() async {
        
        guard let tasksData = try? await service.fetchTasks() else {
            return
        }
                
        loadCompletionState()

        await MainActor.run {
            self.tasks = tasksData
            finishLoading = true
        }
    }
    
    // Closure to bind a task’s completion state
    func binding(for taskId: Int) -> Binding<Bool> {
        Binding(
            get: { [weak self] in
                self?.taskCompletionStateContainer[taskId] ?? false // getting the state of the task from dictionary, if not exist return false
            },
            set: { [weak self] newValue in
                self?.updateCompletion(for: taskId, isCompleted: newValue)
            }
        )
    }
        
    // Update task completion state in userDefults
    func updateCompletion(for taskId: Int, isCompleted: Bool) {
        var updatedStateContainer = taskCompletionStateContainer
        updatedStateContainer[taskId] = isCompleted
        taskCompletionStateContainer = updatedStateContainer // Trigger UI updates
        saveCompletionState(updatedStateContainer)
    }
    
    func addTask(name: String, description: String) {
        // Get the next available ID
        let maxId = tasks.map { $0.id }.max() ?? 0
        let newTaskId = maxId + 1

        let newTask = TaskModel(id: newTaskId, name: name, description: description)
        tasks.append(newTask)
        service.saveNewTask(newTask)
    }

}

// MARK: Handling States with UserDefults
private extension TasksViewModel {
    
    // Save to UserDefaults
    private func saveCompletionState(_ state: [Int: Bool]) {
        // Convert [Int: Bool] to [String: NSNumber] for UserDefults sake
        let convertedState = state.reduce(into: [String: NSNumber]()) { result, entry in
            result["\(entry.key)"] = NSNumber(value: entry.value)
        }
        UserDefaults.standard.set(convertedState, forKey: completionStateKey)
    }
    
    // Load from UserDefaults
    private func loadCompletionState() {
        if let savedState = UserDefaults.standard.dictionary(forKey: completionStateKey) as? [String: NSNumber] {
            DispatchQueue.global(qos: .background).async {
                let processedState = savedState.reduce(into: [Int: Bool]()) { result, entry in
                    if let key = Int(entry.key) {
                        result[key] = entry.value.boolValue
                    }
                }

                DispatchQueue.main.async {
                    self.taskCompletionStateContainer = processedState
                }
            }
        }
    }
}
