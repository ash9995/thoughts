import SwiftUI

struct RecordView: View {
    @State public var textInput: String = ""
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var recordingTimer: Timer?
    @State private var recordingCounter: Int = 0
    @State private var isVisualizing = false
    let userDefaultsKey = "SavedTextInput"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            .padding(.top, 50)
            
            HStack {
                Spacer()
                Text("سؤال: ما الذي حدث ليجعلني أفكر بهذا التفكير؟")
                    .foregroundColor(Color(UIColor(hex: "#514F48")))
//                    .font(getTextFont())
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 13)
                    .padding(.bottom, 13)
                    .font(.custom("mishafi", size: 40))
                    .accessibilityLabel("سؤال: ما الذي حدث ليجعلني أفكر بهذا التفكير؟")
            }
            
            TextField("صف ما تشعر به ", text: $textInput)
                .multilineTextAlignment(.trailing)
                .padding(.bottom, 122.0)
                .padding(.trailing, 8.0)
                .frame(maxWidth: .infinity, maxHeight: 400)
                .frame(width: 350)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding()
            
                .onChange(of: textInput, perform: { value in
                    saveTextToUserDefaults()
                })
                .onAppear {
                    loadTextFromUserDefaults()
                }
                .accessibilityLabel("اجابه طويلة")

                
                RecordingsList(audioRecorder: audioRecorder)
                
                Text(formattedTime(recordingCounter))
                    .font(.system(size: 33))
                    .fontWeight(.thin)
                
                if audioRecorder.recording == false {
                    Button(action: {
                        self.audioRecorder.startRecording()
                        self.startTimer()
                    }) {
                        Text("سجل")
                            .offset(y:4)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.custom("mishafi", size: 40))
                            .padding(.vertical, -15)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor(hex: "#5D5D5D")))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .frame(width: 200)
                            .accessibilityLabel("زر ابدا التسجيل ")
                    }
                } else {
                    Button(action: {
                        self.audioRecorder.stopRecording()
                        self.stopTimer()
                    }) {
                        Text("ايقاف ")
                            .offset(y:4)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.custom("mishafi", size: 40))
                            .padding(.vertical, -7.48)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor(hex: "#5D5D5D")))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .frame(width: 150)
                            .accessibilityLabel("زر ايقاف التسجيل ")
                    }
                }
            }
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: QUSTIONSView()) {
                        HStack {
                            Text("الخلف")
                                .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))

                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
                                .accessibilityLabel("زر")
                        }
                    }
                }
            }
            .padding(.vertical, 40.0)
            .background(Color(UIColor(hex: "#F9F9F8")))
            .edgesIgnoringSafeArea(.all)
//        }
    }
    
    private func startTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.recordingCounter += 1
        }
    }
    
    private func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        recordingCounter = 0
    }
    
    private func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    private func loadTextFromUserDefaults() {
        if let savedText = UserDefaults.standard.string(forKey: userDefaultsKey) {
            textInput = savedText
            print("Text loaded from UserDefaults: \(savedText)")
        }
    }
    private func saveTextToUserDefaults() {
          UserDefaults.standard.set(textInput, forKey: userDefaultsKey)
          print("Text saved to UserDefaults: \(textInput)")
      }
    func getTextFont() -> Font {
           let size: CGFloat = Locale.current.languageCode == "ar" ? 25 : 20
           let fontName: String = Locale.current.languageCode == "ar" ? "mishafi" : "AppleSDGothicNeo-Regular"
           return Font.custom(fontName, size: 20)
       }
    func getTextAlignment() -> TextAlignment {
        let languageCode = Locale.current.languageCode
        return languageCode == "ar" ? .trailing : .leading
    }

}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(audioRecorder: AudioRecorder())
    }
}


let questions = [
    "What happened to make me think this way?",
    "How do you feel today?",
    "What was my reaction?",
    "What makes me believe that this thought is true?",
    "Are there any evidence indicating that this idea might be incorrect?",
    "If this idea is correct, what supports its validity?",
    "The balanced idea",
]
