//
//  TasksListView.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import SwiftUI

struct TasksListView: View {
    
    @StateObject var viewModel = TasksViewModel()
    @State private var showAddTaskSheet = false // State to control sheet visibility
    @State private var didTask = false
    
    struct Constants {
        static let navBarTitle = "Tasks"
        static let addTaskIconSystemName = "plus"
    }
    
    var body: some View {
        ZStack {
            if viewModel.finishLoading {
                TasksView
            } else {
                LoadingView()
            }
        }
        .task {
            await viewModel.loadTasks()
        }
        
        .sheet(isPresented: $showAddTaskSheet) {
            AddTaskView(viewModel: viewModel) // Pass the ViewModel to AddTaskView
        }
    }
    
    private var TasksView: some View {
        NavigationView {
            List(viewModel.tasks) { task in
                TaskRowView(
                    task: task,
                    didTask: viewModel.binding(for: task.id) // Use ViewModel's closure for binding
                )
            }
            .listStyle(InsetListStyle())
            .navigationTitle(Constants.navBarTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTaskSheet = true
                    }) {
                        Image(systemName: Constants.addTaskIconSystemName)
                            .font(.title2)
                            .tint(.indigo)
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
}
    
struct TaskRowView: View {
    let task: TaskModel
    @Binding var didTask: Bool
    
    struct Constants {
        static let stackSpacing: CGFloat = 8
        static let cellRadius: CGFloat = 8
        static let didTaskSystemIcon = "checkmark.square.fill"
        static let didNotDoTaskSystemIcon = "square"
    }
    
    var body: some View {
        
        HStack(alignment: .top, spacing: Constants.stackSpacing) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Checkbox button
            Button(action: {
                didTask.toggle()
            }) {
                HStack {
                    Image(systemName: didTask ? Constants.didTaskSystemIcon: Constants.didNotDoTaskSystemIcon)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(didTask ? .indigo : .gray)
                }
            }
        }
        .padding(8)
        .background(Color.indigo.opacity(0.05))
        .cornerRadius(Constants.cellRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    TasksListView()
}
