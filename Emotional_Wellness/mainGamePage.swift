//
//  mainGamePage.swift
//  Emotional_Wellness
//
//  Created by Linah on 04/04/1446 AH.
//

import SwiftUI
import AVFoundation // For audio playback
import UIKit // For haptics

// Haptic manager class to handle haptic feedback
class HapticManager {
    static let shared = HapticManager()
    
    func createHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

struct MainGameLogicPage: View {
    @State private var tapCount1 = 0
    @State private var tapCount2 = 0
    @State private var tapCount3 = 0
    @State private var tapCount4 = 0
    @State private var tapCount5 = 0
    @State private var tapCount6 = 0

    @State private var showDoll2 = false
    @State private var showDoll3 = false
    @State private var showDoll4 = false
    @State private var showDoll5 = false
    @State private var showDoll6 = false
    @State private var showDoll7 = false

    private let numberOfClouds = 10
    private let cloudSpeed: Double = 10 // Speed of clouds moving
    private let groupSize = 3 // Number of clouds per group

    @State private var cloudPositions: [CGSize] = []
    @State private var cloudOffsets: [CGFloat] = []

    // Single audio player to reuse for all dolls
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            // Light blue sky background
            Color.cyan.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            // Clouds group - Fixed moderate size for all clouds
            ForEach(0..<cloudPositions.count, id: \.self) { index in
                Image(systemName: "cloud.fill")
                    .resizable()
                    .frame(width: 120, height: 80) // Adjusted to a moderate size for all clouds
                    .foregroundColor(.white)
                    .offset(x: cloudPositions[index].width, y: cloudPositions[index].height + cloudOffsets[index])
                    .animation(
                        Animation.linear(duration: cloudSpeed)
                            .repeatForever(autoreverses: false),
                        value: cloudOffsets[index]
                    )
            }

            // Dolls and Angry Images
            if !showDoll2 {
                VStack {
                    // Angry1 shown with Doll1, Doll2
                    Image("angery1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180) // Fixed size for all dolls
                        
                    
                    Image("doll1")
                        .resizable()
                        .frame(width: 250, height: 250) // Fixed size for all dolls
                        .onTapGesture {
                            tapCount1 += 1
                            if tapCount1 >= 3 {
                                playSound()
                                triggerHapticFeedback() // Haptic feedback on every 3rd tap
                                showDoll2 = true
                            }
                        }
                }
            }

            if showDoll2 && !showDoll3 {
                VStack {
                    Image("angery1") // Same angry1 shown with Doll2
                        .resizable()
                        .frame(width: 180)
                    
                    Image("doll2")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            tapCount2 += 1
                            if tapCount2 >= 3 {
                                playSound()
                                triggerHapticFeedback()
                                showDoll3 = true
                            }
                        }
                }
            }

            if showDoll3 && !showDoll4 {
                VStack {
                    Image("angery2") // Angry2 shown with Doll3, Doll4
                        .resizable()
                        .frame(width: 180)
                    
                    Image("doll3")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            tapCount3 += 1
                            if tapCount3 >= 3 {
                                playSound()
                                triggerHapticFeedback()
                                showDoll4 = true
                            }
                        }
                }
            }

            if showDoll4 && !showDoll5 {
                VStack {
                    Image("angery2") // Angry2 still shown with Doll4
                        .resizable()
                        .frame(width: 180)
                    
                    Image("doll4")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            tapCount4 += 1
                            if tapCount4 >= 3 {
                                playSound()
                                triggerHapticFeedback()
                                showDoll5 = true
                            }
                        }
                }
            }

            if showDoll5 && !showDoll6 {
                VStack {
                    Image("angery3") // Angry3 shown with Doll5, Doll6
                        .resizable()
                        .frame(width: 180)
                    
                    Image("doll5")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            tapCount5 += 1
                            if tapCount5 >= 3 {
                                playSound()
                                triggerHapticFeedback()
                                showDoll6 = true
                            }
                        }
                }
            }

            if showDoll6 && !showDoll7 {
                VStack {
                    Image("angery3") // Angry3 still shown with Doll6
                        .resizable()
                        .frame(width: 180)
                    
                    Image("doll6")
                        .resizable()
                        .frame(width: 250)
                        .scaledToFit()
                        .onTapGesture {
                            tapCount6 += 1
                            if tapCount6 >= 3 {
                                playSound()
                                triggerHapticFeedback()
                                showDoll7 = true
                            }
                        }
                }
            }

            if showDoll7 {
                VStack {
                    Image("angery4") // Angry4 shown with Doll7
                        .resizable()
                        .frame(width: 180)
                    
                    Image("doll7")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            playSound()
                            triggerHapticFeedback()
                        }
                }
            }
        }
        .onAppear {
            setupCloudPositions()
            animateClouds()
        }
    }

    // Function to play the same sound for every doll
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    // Trigger haptic feedback using HapticManager
    func triggerHapticFeedback() {
        HapticManager.shared.createHapticFeedback()
    }

    // Generate random cloud positions and initialize offsets for animation
    func setupCloudPositions() {
        var positions: [CGSize] = []
        var offsets: [CGFloat] = []

        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        for _ in 0..<numberOfClouds {
            let newPosition = CGSize(
                width: CGFloat.random(in: -screenWidth / 4...screenWidth / 2),
                height: CGFloat.random(in: screenHeight...screenHeight + 200)
            )
            positions.append(newPosition)
            offsets.append(0)
        }

        cloudPositions = positions
        cloudOffsets = offsets
    }

    // Animate the clouds by applying an upward movement and resetting when off-screen
    func animateClouds() {
        let screenHeight = UIScreen.main.bounds.height

        for i in 0..<numberOfClouds {
            let delay = Double(i % groupSize) * 0.5

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(Animation.linear(duration: cloudSpeed).repeatForever(autoreverses: false)) {
                    if i < cloudOffsets.count {
                        cloudOffsets[i] = -screenHeight - CGFloat(i * 500)
                    }
                }
            }
        }
    }

}

#Preview {
    MainGameLogicPage()
}