import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    @State private var selectedOption: String = ""
    @State private var isAddTaskTextVisible = true
    @Environment(\.locale) private var locale
    @Query var taskslist: [TaskModel]

    let white1 = Color(red: 249, green: 249, blue: 248)
    let audioRecorder: AudioRecorder
    
    init(audioRecorder: AudioRecorder) {
        self.audioRecorder = audioRecorder
    }
    
    var body: some View {
        VStack {
            Text("My thoughts")
                .font(.custom("mishafi", size: 80))
                .foregroundColor(Color(red: 0.471, green: 0.483, blue: 0.457))
                .multilineTextAlignment(.trailing)
                .offset(x: locale.languageCode == "ar" ? 110:120)
                .onReceive(NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)) { _ in
                    // Reload the view or update the UI when the locale changes
                }

            ZStack {
                if isAddTaskTextVisible {
                    Text("اضف ما باخلك ")
                        .font(.custom("mishafi", size: 45))
                        .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
                        .offset(x: locale.languageCode == "ar" ? -6 : 6, y: 200)
                        .navigationBarBackButtonHidden(true)
                }
            }

            List {
                ForEach(tasks.indices, id: \.self) { index in
                    NavigationLink(destination: QUSTIONSView()) {
                        TaskRow(task: $tasks[index])
                            .accessibilityLabel("الفكرة رقم \(index + 1): \(tasks[index].name)")
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }

            Button(action: {
                self.showingAddTask = true
            }) {
                Text("اضف فكرتك")
                    .fontWeight(.ultraLight)
                    .offset(y: 5)
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.custom("mishafi", size: 40))
                    .font(.custom(locale.languageCode == "ar" ? "mishafi" : "AppleSDGothicNeo-Regular", size: locale.languageCode == "ar" ? 25 : 25))
                    .padding(.vertical, -15)
                    .frame(maxWidth: .infinity)
                    .background(Color.fontcolor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .frame(width: 200)
                    .offset(x: locale.languageCode == "ar" ? 15 : 20)
                    .padding()

                HStack {
                    Image(systemName: "plus")
                        .offset(x: locale.languageCode == "ar" ? -50
                            : -40, y: 0)
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color(red: 249, green: 249, blue: 248))
                        .accessibilityLabel("اضافة فكرة جديدة")
                }
            }
        }
        .navigationBarItems(trailing: menuButton)
        .background(Color(red: 0.976, green: 0.976, blue: 0.972))
        .background(white1)
        .scrollContentBackground(.hidden)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadTasksFromUserDefaults()
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(isShowing: $showingAddTask) { task in
                self.tasks.append(task)
                saveTasksToUserDefaults()
                isAddTaskTextVisible = false
            }
            .presentationDetents([.height(250), .height(500)])
        }
        .onAppear {
            loadTasksFromUserDefaults()
        }
    }

    private var menuButton: some View {
        Menu {
            Button(role: .destructive, action: {
                selectedOption = ""
                tasks.removeAll()
            }) {
                Label("Delete All", systemImage: "trash")
                    .foregroundColor(.red)
            }
        } label: {
            Label(selectedOption, systemImage: "ellipsis.circle")
                .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        saveTasksToUserDefaults()
    }

    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasksToUserDefaults()
    }

    private func saveTasksToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    private func loadTasksFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? decoder.decode([Task].self, from: data){
            self.tasks = decodedTasks
        }
    }
    func getTextFont() -> Font {
            let size = locale.languageCode == "ar" ? 25 : 20
            return locale.languageCode == "ar" ? Font.custom("mishafi", size: 30) : Font.custom("AppleSDGothicNeo-Regular", size: 40)
        }
    }

    


struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var completed: Bool = false
}

struct TaskRow: View {
    @Binding var task: Task
    @State private var isEditing = false

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(task.name)
                            .font(.headline)
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var taskName: String = ""

    var isShowing: Binding<Bool>
    var saveTask: (Task) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("عنوان الفكره ", text: $taskName)
//                    .font(.custom("mishafi", size: 20))
                    .multilineTextAlignment(.center)
            }
            .navigationBarTitle(Text("اضف فكرتك").font(.custom("mishafi", size: 20)), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("الغاء")
                        .foregroundColor(Color(red: 249, green: 249, blue: 248))
                },
                trailing: Button(action: {
                    let task = Task(name: self.taskName)
                    self.saveTask(task)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("حفظ")
                        .foregroundColor(Color(red: 249, green: 249, blue: 248))
                }
            )
            .scrollContentBackground(.hidden)
            .shadow(color: Color.black.opacity(0.1),
                    radius: 5, x: 0, y: 5)
            .background(Color(red: 164/255, green: 168/255, blue: 150/255))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
