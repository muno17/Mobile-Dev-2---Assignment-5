//
//  TodoViewModel.swift
//  Assignment 5
//
//  Created by Danny Muñoz on 11/19/26.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Combine

class TodoViewModel : ObservableObject {
    @Published var todos: [TodoModel] = []

    let db = Firestore.firestore()

    // each user gets their own collection: users/{uid}/todos
    private func collection(for uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("todos")
    }

    @MainActor
    func fetchData(uid: String) async {
        todos.removeAll()

        do {
            let querySnapshot = try await collection(for: uid).getDocuments()
            for document in querySnapshot.documents {
                do {
                    todos.append(try document.data(as: TodoModel.self))
                } catch {
                    print(error)
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }

    func saveData(todo: TodoModel, uid: String) {
        do {
            if !todo.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                if let id = todo.id {
                    try collection(for: uid).document(id).setData(from: todo)
                    // keep the on-screen list in sync with what was just saved
                    if let index = todos.firstIndex(where: { $0.id == id }) {
                        todos[index] = todo
                    }
                } else {
                    try collection(for: uid).addDocument(from: todo)
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }

    func deleteData(todo: TodoModel, uid: String) {
        if let id = todo.id {
            collection(for: uid).document(id).delete()
        }
    }
}
