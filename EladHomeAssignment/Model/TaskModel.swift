//
//  TaskModel.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import Foundation


struct TaskModel: Identifiable, Codable {  // Codable for simulating real service call
    var id: Int
    var name: String
    var description: String
}
