import SwiftUI

struct SplashScreen: View {
    let backgroundColor: Color = Color(red: 249 / 255.0, green: 249 / 255.0, blue: 248 / 255.0)
    @State private var isShowingImages = false
    @State private var isButtonTapped = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("Image 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                    .accessibilityLabel("رحيب")
                
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 280.0)
                    .offset(x: 15, y: 10)
                    .opacity(isShowingImages ? 1 : 0)
                    .animation(.easeInOut(duration: 3))
                    .accessibilityLabel("صوره قلم")
                
                Spacer()
                
                Text("رحيب يقدم أسئلة تساعدك في استكشاف وفهم جذور الأفكار السلبية في ذهنك. انضم إلينا في رحلة تحسين تفكيرك وتغيير السلبية إلى إيجابية، لتحقيق حياة أكثر سعادة وتوازنًا.")
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("رحيب يقدم أسئلة تساعدك في استكشاف وفهم جذور الأفكار السلبية في ذهنك. انضم إلينا في رحلة تحسين تفكيرك وتغيير السلبية إلى إيجابية، لتحقيق حياة أكثر سعادة وتوازنًا.")
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.318, green: 0.309, blue: 0.284))
                    .multilineTextAlignment(getTextAlignment())
//                    .font(getTextFont())
                    .font(.custom("mishafi", size: 30))
                    .padding(.horizontal, 15.0)
                    .opacity(isShowingImages ? 1 : 0)
                    .animation(.easeInOut(duration: 2))
                
                NavigationLink(
                    destination: ContentView(audioRecorder: AudioRecorder()),
                    isActive: $isButtonTapped,
                    label: {
                        Text("إبدأ")
                            .font(.custom("mishafi", size: 33))
                            .foregroundColor(Color(red: 249 / 255.0, green: 249 / 255.0, blue: 248 / 255.0))
                            .padding()
                            .offset(x: -2)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.fontcolor) // Replace with your desired background color
                            .frame(width: 80, height: 48.0)
                            .cornerRadius(15)
                            .offset(x: 2, y: 30)
                            .padding()
                            .opacity(isShowingImages ? 1 : 0)
                            .animation(.easeInOut(duration: 2))
                            .accessibilityLabel("زر إبدأ ")
                    })
                    .padding(.bottom, 50)
            }
            .background(backgroundColor)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isShowingImages = true
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func getTextAlignment() -> TextAlignment {
        let languageCode = Locale.current.languageCode
        return languageCode == "ar" ? .trailing : .leading
    }

    func getTextFont() -> Font {
        let languageCode = Locale.current.languageCode
        return languageCode == "ar" ? Font.custom("mishafi", size: 25) : Font.custom("AppleSDGothicNeo-Regular", size: 20)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
