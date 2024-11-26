//
//  TaskService.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import Foundation

protocol TasksServiceProtocol {
    func fetchTasks() async throws -> [TaskModel]
}

final class TasksService: TasksServiceProtocol {
    
    // MARK: Variables
    private lazy var apiClient = TasksApiClient()
    
    // MARK: Method
    func fetchTasks() async throws -> [TaskModel] {
        do {
            let tasksData = try await apiClient.fetchTasks()
            return tasksData
        } catch (let error) {
            throw error
        }
    }
    
    func saveNewTask(_ task: TaskModel) {
        apiClient.saveTaskToUserDefaults(task)
    }
}
