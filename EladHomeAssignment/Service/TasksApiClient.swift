//
//  TasksApiClient.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import Foundation

protocol TasksApiClientProtocol {
    func fetchTasks() async throws -> [TaskModel]
}

final class TasksApiClient: TasksApiClientProtocol {
    
    struct Constants {
        static let path = "some_path_name.json"
        static let userDefaultsKey = "savedTasks"
    }
    
    enum UserApiError: Error {
        case invalidUrl
    }
    
    func fetchTasks() async throws -> [TaskModel] {
        
        let urlPathIsValid = true
        guard urlPathIsValid else { // Simulating validity check of url
            throw UserApiError.invalidUrl
        }
        
        // Mock service data
        let mockTasks: [TaskModel] = [
            TaskModel(id: 1, name: "Buy groceries", description: "Pick up essentials like milk, bread, and vegetables from the supermarket."),
            TaskModel(id: 2, name: "Morning workout", description: "Complete a 30-minute workout session at the gym or home."),
            TaskModel(id: 3, name: "Reply to emails", description: "Respond to important emails in your inbox."),
            TaskModel(id: 4, name: "Team meeting", description: "Join the team meeting to discuss the progress of the current project."),
            TaskModel(id: 5, name: "Pick up kids", description: "Drive to the school and pick up the kids at 3 PM."),
            TaskModel(id: 6, name: "Pay bills", description: "Settle utility bills like electricity, water, and internet before the due date."),
            TaskModel(id: 7, name: "Prepare dinner", description: "Cook a healthy and delicious meal for the family."),
            TaskModel(id: 8, name: "Walk the dog", description: "Take the dog for a 20-minute evening walk around the park."),
            TaskModel(id: 9, name: "Read a book", description: "Spend 15 minutes reading a chapter from your favorite book."),
            TaskModel(id: 10, name: "Clean the house", description: "Vacuum the floors and tidy up the living room and kitchen."),
            TaskModel(id: 11, name: "Call parents", description: "Make a quick phone call to check in on your parents."),
            TaskModel(id: 12, name: "Water the plants", description: "Water all indoor and outdoor plants in the garden."),
            TaskModel(id: 13, name: "Finish report", description: "Complete the financial report for this month's expenses."),
            TaskModel(id: 14, name: "Schedule doctor’s appointment", description: "Call the clinic to book a general health checkup."),
            TaskModel(id: 15, name: "Plan weekend trip", description: "Research and decide on a destination for this weekend's family outing.")
        ]
        
        // Here I want to get the new items added to the list from user defults

        // Fetch tasks saved in UserDefaults
        let savedTasks = retrieveSavedTasksFromUserDefaults()
        
        // Filter out mock tasks that have the same `id` as saved tasks
        let filteredMockTasks = mockTasks.filter { mockTask in
            !savedTasks.contains(where: { $0.id == mockTask.id })
        }
        
        // Combine mock tasks with saved tasks
        let allTasks = mockTasks + savedTasks
        return allTasks
    }
    
    // Methods for retreving new tasks that were added by the user

    private func retrieveSavedTasksFromUserDefaults() -> [TaskModel] {
        guard let savedData = UserDefaults.standard.data(forKey: Constants.userDefaultsKey),
              let savedTasks = try? JSONDecoder().decode([TaskModel].self, from: savedData) else {
            return []
        }
        return savedTasks
    }
    
    func saveTaskToUserDefaults(_ task: TaskModel) {
        var savedTasks = retrieveSavedTasksFromUserDefaults()
        savedTasks.append(task)
        
        if let encodedData = try? JSONEncoder().encode(savedTasks) {
            UserDefaults.standard.set(encodedData, forKey: Constants.userDefaultsKey)
        }
    }
}
