//
//  NotificationsView.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 24/05/2023.
//

import SwiftUI
import FirebaseFirestore

// The view for the notifications screen.
struct NotificationsView: View {
    // State object for the notification view model
    @StateObject var notificationViewModel: NewReminderViewModel = NewReminderViewModel()
    // Namespace for animations
    @Namespace var animation
    // Edit mode environment variable
    @Environment(\.editMode) var editButton
    // State variable for storing tasks
    @State private var tasks: [ToDoListItem] = []

    
    var body: some View {
        // Main content of the view wrapped in a ScrollView
        ScrollView(.vertical, showsIndicators: false) {
            
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                // Section for the header and task views
                Section{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(notificationViewModel.currentWeek, id: \.self){
                                day in
                                VStack(spacing: 10){
                                    // Add gesture recognizer
                                    Text(notificationViewModel.extractDate(date: day, format: "dd")).font(.system(size: 15)).fontWeight(.semibold)
                                    
                                    Text(notificationViewModel.extractDate(date: day, format: "EEE")).font(.system(size: 14))
                                    // Indicator for the current day
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(notificationViewModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(notificationViewModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(notificationViewModel.isToday(date: day) ? .white: .black)
                                .frame(width:45, height: 90).background(
                                    ZStack{
                                        if notificationViewModel.isToday(date: day){
                                            Capsule().fill(.black).matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                ).contentShape(Capsule())
                                    .onTapGesture {
                                        // Filter tasks for the selected day
                                        tasks = notificationViewModel.filterTask(dateToFilter: day) ?? []
                                        withAnimation{
                                            notificationViewModel.currentDay = day
                                        }
                                    }
                            }
                        }.padding(.horizontal)
                    }
                    // View for displaying tasks
                    TasksView()
                } header: {
                    // Header view for displaying current date and edit button
                    HeaderView()
                }
            }
        }.ignoresSafeArea(.container, edges: .top)
        // Add button for creating new tasks
            .overlay(Button(action: {
                notificationViewModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black, in: Circle())
            })
                .padding()
                     , alignment: .bottomTrailing
            )
        // Present the NewReminderView as a sheet when addNewTask is toggled
            .sheet(isPresented:$notificationViewModel.addNewTask){
                notificationViewModel.editTask = nil
            } content: {
                NewReminderView()
                    .environmentObject(notificationViewModel)
            }
            .onAppear {
                // Load tasks from Firebase Firestore when the view appears
                notificationViewModel.startListeningForTasks()
            }
            .onDisappear{
                // Stop listening
                notificationViewModel.stopListeningForTasks()
            }
    }
    
    /// Displays the list of tasks.
    func TasksView() -> some View {
        LazyVStack(spacing: 20) {
            ForEach(tasks) { task in
                TaskCardView(task: task)
            }
            }
            .padding()
            .padding(.top)
        }
    
    /// Displays a task card.
    func TaskCardView(task: ToDoListItem)-> some View{
            HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30){
                //IF edit mode enabled them show delete button
                if editButton?.wrappedValue == .active{
                    VStack(spacing: 10){
                        
                        Button {
                            // Delete button for removing a task
                            notificationViewModel.deleteTask(task: task)
                            tasks = notificationViewModel.filterTask(dateToFilter: task.dueDate ?? Date()) ?? []
                        }label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }
                }
                else{
                    VStack(spacing: 10){
                        Circle()
                            .fill(!notificationViewModel.isCurrentHour(date: task.dueDate ?? Date()) ? (task.isDone ? .green : .black) : .clear)
                            .frame(width: 15, height: 15)
                            .background(
                                Circle()
                                    .stroke(.black, lineWidth: 1)
                                    .padding(-3)
                            )
                            .scaleEffect(!notificationViewModel.isCurrentHour(date: task.dueDate ?? Date()) ? 0.8 : 1)
                        Rectangle()
                            .fill(.black)
                            .frame(width: 3)
                    }
                }
                
                VStack{
                    HStack(alignment: .top, spacing: 10){
                        VStack(alignment: .leading, spacing: 12){
                            // Display the task title and description
                            Text(task.title ?? "").font(.title2).fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(task.description ?? "").font(.subheadline).foregroundColor(.gray)
                        }
                        .hLeading()
                        // Display the due date of the task
                        Text(task.dueDate?.formatted(date: .omitted, time: .shortened) ?? "")
                            .foregroundColor(.white)
                    }
                    if notificationViewModel.isCurrentHour(date: task.dueDate ?? Date()){
                        HStack(spacing:12){
                            if !task.isDone{
                                Button{
                                    // Button to mark the task as completed
                                    notificationViewModel.toggleDone(task: task)
                                    tasks = notificationViewModel.filterTask(dateToFilter: task.dueDate ?? Date()) ?? []

                                } label: {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.black)
                                        .padding(10)
                                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            Text(task.isDone ? "Marked as Completed" : "Mark Task as Completed")
                                .font(.system(size: task.isDone ? 14 : 16, weight: .light))
                                .foregroundColor(task.isDone ? .gray : .white)
                                .hLeading()
                        }
                        .padding(.top)
                    }
                }
                .foregroundColor(notificationViewModel.isCurrentHour(date: task.dueDate ?? Date()) ? .white : .black)
                .padding(notificationViewModel.isCurrentHour(date: task.dueDate ?? Date()) ? 15 : 10)
                .padding(.bottom, notificationViewModel.isCurrentHour(date: task.dueDate ?? Date()) ? 0 : 10)
                .hLeading()
                .background(Color.black)
                .cornerRadius(15)
                
            }
        .hLeading()
    }
    
    /// Displays the header view.
    func HeaderView() -> some View{
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 10){
                // Display the abbreviated current date
                Text(Date().formatted(date: .abbreviated, time: .omitted)).foregroundColor(.gray)
                // Display the abbreviated current date
                Text("Today").font(.largeTitle.bold())
            }.hLeading()
            
            EditButton()
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

/// Extension to provide additional convenience functions to the View protocol
extension View{
    /// Positions the view to the leading edge.
    func hLeading() -> some View{
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Positions the view to the trailing edge.
    func hTraiLing() -> some View{
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    /// Positions the view to the center.
    func hCenter() -> some View{
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    /// Retrieves the safe area insets of the screen.
    func getSafeArea()-> UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        // Get the safe area insets of the current window
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}

/// Hosting controller for the NotificationsView.
class NotificationsHostingController: UIHostingController<NotificationsView>{
    required init? (coder: NSCoder){
        super.init(coder: coder, rootView: NotificationsView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

