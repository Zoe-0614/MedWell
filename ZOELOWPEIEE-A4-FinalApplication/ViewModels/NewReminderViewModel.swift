//
//  NewReminderViewModel.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 10/05/2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import UIKit

/// The view model class for managing new reminders.
class NewReminderViewModel: ObservableObject, DatabaseListener{
    
    // MARK: - Published Properties
    
    /// The type of listener for the database.
    @Published var listenerType = ListenerType.todos
    /// The database controller for managing database operations.
    @Published var databaseController: DatabaseProtocol?
    /// The list of to-do items.
    @Published var todoList: [ToDoListItem]?
    /// The title of the reminder.
    @Published var title = ""
    /// The description of the reminder.
    @Published var description = ""
    /// The due date of the reminder.
    @Published var dueDate = Date()
    /// Flag to control showing an alert.
    @Published var showAlert = false
    /// The current week as a list of dates.
    @Published var currentWeek: [Date] = []
    /// The current day.
    @Published var currentDay: Date = Date()
    /// The filtered tasks based on the current day.
    @Published var filteredTasks: [ToDoListItem]?
    /// Flag to indicate whether to add a new task.
    @Published var addNewTask: Bool = false
    /// The task to edit.
    @Published var editTask: ToDoListItem?
    
    /// Initializes the `NewReminderViewModel`.
    init(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        fetchCurrentWeek()
        filteredTasks = todoList
    }
    
    //MARK: - Methods
    
    /// This method fetches the current week.
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    /// This method extracts a formatted string representation of a date.
    /// - Parameters:
    ///   - date: The date to extract.
    ///   - format: The date format string.
    /// - Returns: The formatted string representation of the date.
    func extractDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// This method checks if a given date represents today.
    /// - Parameter date: The date to check.
    /// - Returns: `true` if the date is today, `false` otherwise.
    func isToday(date: Date)-> Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    /// Checks if a given date represents the current hour.
    /// - Parameter date: The date to check.
    /// - Returns: `true` if the date is the current hour, `false` otherwise.
    func isCurrentHour(date: Date) -> Bool{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currentHour)
    }
    
    /// Starts listening for tasks changes in the database.
    func startListeningForTasks(){
        databaseController?.addListener(listener: self)
        databaseController?.setupTodosListener()
    }
    
    /// Stops listening for tasks changes in the database.
    func stopListeningForTasks() {
        databaseController?.disposeTodosListener()
    }
    
    /// This callback method called when there are changes to the list of todos in the database.
    /// - Parameters:
    ///   - change: The type of database change.
    ///   - todos: The updated list of to-do items.
    func onAllTodosChange(change: DatabaseChange, todos: [ToDoListItem]) {
        self.todoList = todos
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: currentDay)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        
        filteredTasks = todoList!.filter({ (task: ToDoListItem) -> Bool in
            return (calendar.isDate(task.dueDate!, inSameDayAs: today) ||
                    (task.dueDate! >= today && task.dueDate! < tomorrow!))
        })
    }
    
    /// This method filters the todos based on a given date.
    /// - Parameter dateToFilter: The date to filter the tasks.
    /// - Returns: The filtered todos for the given date.
    func filterTask(dateToFilter: Date)->[ToDoListItem]?{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        
        filteredTasks = todoList!.filter({ (task: ToDoListItem) -> Bool in
            return (calendar.isDate(task.dueDate!, inSameDayAs: today) ||
                    (task.dueDate! >= today && task.dueDate! < tomorrow!))
        })
        
        return filteredTasks
    }
    
    /// Saves the new reminder.
    func save(){
        //Pop View Controller
        guard canSave else{
            return
        }
        
        //Get current user ID
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        //Create model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(
            title: title,
            description: description,
            dueDate: dueDate,
            createdDate: Date(),
            isDone: false,
            name: "Todo"
        )
        
        let data: [String: Any] = [
            "name": newItem.name!,
            "title": newItem.title!,
            "description": newItem.description!,
            "dueDate": newItem.dueDate!,
            "createdDate": newItem.createdDate!,
            "isDone": newItem.isDone
        ]
        
        //Save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(newId)
            .setData(data)
        
        //Create local notifications
        if newItem.isDone == false {
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = newItem.title!
            content.sound = .default
            let reminderDate = newItem.dueDate!
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
    }
    
    /// Deletes a task.
    /// - Parameter task: The task to delete.
    func deleteTask(task: ToDoListItem){
        guard let taskId = task.id else { return }
        // Remove the task from the view model
        if let index = todoList?.firstIndex(where: { $0.id == taskId }) {
            todoList?.remove(at: index)
        }
        
        // Delete the task from the database
        databaseController?.deleteTodos(todos: task)
        
        // Cancel the notification associated with the task
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
        
        if let index = filteredTasks?.firstIndex(where: { $0.id == taskId }) {
            filteredTasks?.remove(at: index)
        }
    }
    
    /// Toggles the completion status of a task.
    /// - Parameter task: The task to toggle.
    func toggleDone(task: ToDoListItem) {
        guard let taskId = task.id else { return }
        
        let isDone = !task.isDone
        
        // Update the task's isDone property in the database
        databaseController?.updateTodoItem(withId: taskId, isDone: isDone)
        
        // Schedule or cancel a notification based on the task's completion status
        if isDone {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
        } else {
            guard let title = task.title, let dueDate = task.dueDate else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = title
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: taskId, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    /// Determines whether the reminder can be saved.
    var canSave: Bool{
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
    
    /// Not implemented - not used
    func onAllChannelsChange(change: DatabaseChange, channels: [Channel], currentSender: Sender) {
    }
    
}
