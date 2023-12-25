//
//  RecordingsList.swift
//  Voice Recorder
//
//  Created by Pinlun on 2019/10/30.
//  Copyright © 2019 Pinlun. All rights reserved.
//

import SwiftUI

struct RecordingsList: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
            }
            .onDelete(perform: delete)
        }
        .listStyle(PlainListStyle()) // Set list style to PlainListStyle
        .background(Color(UIColor(hex: "#F9F9F8")))
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}
struct RecordingRow: View {
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()

    var body: some View {
        ZStack {
            Color(UIColor(hex: "#F9F9F8"))
                .frame(maxWidth: .infinity, minHeight: 60)

            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 60)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

            HStack {
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        self.audioPlayer.startPlayback(audio: self.audioURL)
                    }) {
                        Image(systemName: "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25.0, height: 25.0)
                            .foregroundColor(Color(UIColor(hex: "#5D5D5D"))) // Set the image color to #5D5D5D
                            .padding(.leading, 8.0)
                    }
                } else {
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0, height: 40.0)
                            .foregroundColor(Color(UIColor(hex: "#5D5D5D"))) // Set the image color to #5D5D5D
                    }
                    .background(Color(UIColor(hex: "#F9F9F8")))
                }

                Text("\(audioURL.lastPathComponent)")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(UIColor(hex: "#5D5D5D"))) // Set the text color to #5D5D5D
                    .padding(16)
                    .lineLimit(1)
            }
        }
        .padding(9)
    }
}
struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
//
//  RecordingsList.swift
//  thoughts
//
//  Created by aisha rashid alshammari  on 10/06/1445 AH.
//

