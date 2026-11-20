import SwiftUI
import FirebaseAuth

struct ContentView: View {

    @EnvironmentObject var todovm : TodoViewModel
    @EnvironmentObject var auth : AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink {
                    TodoDetail(todo: TodoModel(title: "", content: "", isDone: false))
                } label: {
                    Text("+ Add New To-Do")
                        .foregroundStyle(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }

                List {
                    ForEach(todovm.todos) { todo in
                        NavigationLink {
                            TodoDetail(todo: todo)
                        } label: {
                            HStack {
                                Button {
                                    toggleDone(todo)
                                } label: {
                                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                                }
                                .buttonStyle(.borderless)

                                Text(todo.title)
                                    .strikethrough(todo.isDone)
                            }
                        }
                    }
                    .onDelete { offsets in
                        guard let uid = auth.user?.uid else { return }
                        for index in offsets {
                            todovm.deleteData(todo: todovm.todos[index], uid: uid)
                        }
                        todovm.todos.remove(atOffsets: offsets)
                    }
                }
            }
            .navigationTitle("My To-Dos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        auth.logout()
                    }
                }
            }
            .task {
                if let uid = auth.user?.uid {
                    await todovm.fetchData(uid: uid)
                }
            }
        }
    }

    func toggleDone(_ todo: TodoModel) {
        guard let uid = auth.user?.uid,
              let index = todovm.todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todovm.todos[index].isDone.toggle()
        todovm.saveData(todo: todovm.todos[index], uid: uid)
    }
}

#Preview {
    ContentView()
        .environmentObject(TodoViewModel())
        .environmentObject(AuthViewModel())
}
