//
//  TodoDetail.swift
//  Assignment 5
//
//  Created by Danny Muñoz on 11/19/26.
//

import SwiftUI
import FirebaseAuth

struct TodoDetail: View {

    @Binding var todo : TodoModel
    @EnvironmentObject var todovm : TodoViewModel
    @EnvironmentObject var auth : AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("What needs to be done?", text: $todo.title)
                .font(.title)
                .fontWeight(.bold)

            TextEditor(text: $todo.content)
                .frame(minHeight: 120)

            Toggle("Completed", isOn: $todo.isDone)

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if let uid = auth.user?.uid {
                        todovm.saveData(todo: todo, uid: uid)
                    }
                    todo.title = ""
                    todo.content = ""
                    todo.isDone = false
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TodoDetail(todo: .constant(TodoModel(title: "Buy milk", content: "2%", isDone: false)))
        .environmentObject(TodoViewModel())
        .environmentObject(AuthViewModel())
}
