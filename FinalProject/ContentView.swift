//
//  ContentView.swift
//  FinalProject
//
//  Created by Nikolay Volnikov on 22.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var location: CGPoint = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    @State private var startLocation: CGPoint?
    @State private var fingerLocation: CGPoint? // 1

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.location = value.location
            }
    }

    var fingerDrag: some Gesture { // 2
        DragGesture()
            .onChanged { value in
                self.fingerLocation = value.location
            }
            .onEnded { value in
                self.fingerLocation = startLocation

                withAnimation(.spring(.bouncy, blendDuration: 1)) {
                    self.location = startLocation ?? CGPoint()
                }
            }
    }

    var body: some View {
        GeometryReader { reader in // 1
            ZStack { // 3
                Circle()
                    .fill(.black)
                    .blur(radius: 20.0)
                    .frame(width: 150, height: 150)
                    .allowsHitTesting(false)

                Circle()
                    .fill(.black)
                    .blur(radius: 20.0)
                    .frame(width: 150, height: 150)
                    .position(location)
                    .gesture(
                        simpleDrag.simultaneously(with: fingerDrag) // 4
                    )
                    .onAppear(perform: {
                        location = CGPoint(x: reader.size.width/2, y: reader.size.height/2)
                        startLocation = location
                    })
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .overlay(
                Color(white: 0.5)
                    .blendMode(.colorBurn)
                    .allowsHitTesting(false)// 2
            )
            .overlay(
                Color(white: 1.0)
                    .blendMode(.colorDodge)
                    .allowsHitTesting(false)// 3
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
