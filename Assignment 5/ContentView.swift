import SwiftUI
import FirebaseAuth

struct ContentView: View {

    @EnvironmentObject var todovm : TodoViewModel
    @EnvironmentObject var auth : AuthViewModel
    @State var newTodo = TodoModel(title: "", content: "", isDone: false)

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    TodoDetail(todo: $newTodo)
                } label: {
                    Text("+ Add New To-Do")
                        .foregroundStyle(.blue)
                }

                ForEach($todovm.todos) { $todo in
                    NavigationLink {
                        TodoDetail(todo: $todo)
                    } label: {
                        HStack {
                            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
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
}

#Preview {
    ContentView()
        .environmentObject(TodoViewModel())
        .environmentObject(AuthViewModel())
}
