//
//  NewReminderView.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 10/05/2023.
//

import SwiftUI

/// The view for adding a new reminder.
struct NewReminderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = NewReminderViewModel()
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    // Text field for entering the reminder title
                    TextField("", text: $viewModel.title)
                } header: {
                    // Section header for the title
                    Text("Title")
                }
                Section{
                    // Text field for entering the reminder description
                    TextField("", text: $viewModel.description)
                } header: {
                    // Section header for the description
                    Text("Description")
                }
                
                if viewModel.editTask == nil{
                    Section{
                        // DatePicker for selecting the due date
                        DatePicker("", selection: $viewModel.dueDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        // Section header for the due date
                        Text("Due Date")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        if viewModel.canSave{
                            // Save the reminder
                            viewModel.save()
                        } else {
                            // Show an error alert if the reminder is not valid
                            viewModel.showAlert = true
                        }
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        // Dismiss the view
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert){
                Alert(title: Text("Error"), message: Text("Please fill in all fields and select due date that is today or nearer."))
            }
        }
    }
}

/// Preview
struct NewReminderView_Previews: PreviewProvider{
    static var previews: some View{
        NewReminderView()
    }
}

/// Hosting controller for the NewReminderView.
class NewReminderHostingController: UIHostingController<NewReminderView>{
    required init? (coder: NSCoder){
        super.init(coder: coder, rootView: NewReminderView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
