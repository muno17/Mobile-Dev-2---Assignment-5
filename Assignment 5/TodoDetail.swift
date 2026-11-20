//
//  TodoDetail.swift
//  Assignment 5
//
//  Created by Danny Muñoz on 11/19/26.
//

import SwiftUI
import FirebaseAuth

struct TodoDetail: View {

    @State private var draft : TodoModel
    @EnvironmentObject var todovm : TodoViewModel
    @EnvironmentObject var auth : AuthViewModel
    @Environment(\.dismiss) var dismiss

    init(todo: TodoModel) {
        _draft = State(initialValue: todo)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("What needs to be done?", text: $draft.title)
                .font(.title)
                .fontWeight(.bold)

            TextField("Details", text: $draft.content, axis: .vertical)
                .lineLimit(5...)

            Toggle("Completed", isOn: $draft.isDone)

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if let uid = auth.user?.uid {
                        todovm.saveData(todo: draft, uid: uid)
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TodoDetail(todo: TodoModel(title: "Buy milk", content: "2% or whole", isDone: false))
        .environmentObject(TodoViewModel())
        .environmentObject(AuthViewModel())
}
