import SwiftUI

struct QUSTIONSView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var textInput: String = ""
    @State private var buttonStates = Array(repeating: false, count: 7)
    let white1 = Color(red: 249, green: 249, blue: 248)

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Spacer()
                        .font(.custom("SF Pro Rounded", size: 50))
                        .foregroundColor(Color("Text-Primary"))
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .padding(5)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: ContentView(audioRecorder: AudioRecorder())) {
                            HStack {
                                Text("انهاء")
                                    .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
                                    .accessibilityLabel("Done button")
                            }
                        }
                    }
                }

                VStack(spacing: 14) {
                    ForEach(0..<7) { index in
                        NavigationLink(destination: RecordView(audioRecorder: AudioRecorder())) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(getButtonBackground(forIndex: index))
                                    .frame(width: 360, height: 100)
                                    .cornerRadius(10)
                                    .shadow(color: Color.fontcolor.opacity(0.3), radius: 5, x: 0, y: 5)

                                Text(getButtonText(forIndex: index))
                                    .font(.custom("mishafi", size: 24))
                                    .foregroundColor(getButtonTextColor(forIndex: index))
                                    .multilineTextAlignment(getTextAlignment())
                                    .padding(.leading, 2)
                                    .accessibility(label: Text("زر \(getButtonText(forIndex: index))"))
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibility(label: Text("زر \(getButtonText(forIndex: index))"))
                    }
                }
                .padding(.horizontal)

                Color(.white1)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func getButtonText(forIndex index: Int) -> String {
        switch index {
        case 0: return "ما الذي حدث ليجعلني أفكر بهذا التفكير؟"
        case 1: return "كيف تشعر اليوم؟"
        case 2: return "ماذا كان رد فعلي؟"
        case 3: return "ما الذي يجعلني اعتقد ان هذه الفكره صحيحة؟"
        case 4: return "هل توجد أي أدلة تشير إلى أن هذه الفكرة غير صحيحة؟"
        case 5: return "اذا كانت الفكره صحيحة ما الذي يدعم صحتها؟"
        case 6: return "الفكرة المتوازنه"
        default: return ""
        }
    }

    func getButtonBackground(forIndex index: Int) -> Color {
        return buttonStates[index] ? Color.green1 : Color.white
    }

    func getButtonTextColor(forIndex index: Int) -> Color {
        return buttonStates[index] ? .white : .fontcolor
    }

    func getTextAlignment() -> TextAlignment {
        let languageCode = Locale.current.languageCode
        return languageCode == "ar" ? .trailing : .leading
    }

    func speakContent(_ content: String) {
        // Implement text-to-speech functionality here
        // You can use AVSpeechSynthesizer or other libraries to speak the content
        // For simplicity, we'll just print the content here
        print("Spoken Content: \(content)")
    }
}

struct QUSTIONSView_Previews: PreviewProvider {
    static var previews: some View {
        QUSTIONSView()
    }
}
