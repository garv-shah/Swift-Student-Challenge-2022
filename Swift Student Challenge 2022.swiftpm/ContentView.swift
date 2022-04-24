//
//  File.swift
//  Orbit
//
//  Created by Garv Shah on 22/4/2022.
//

import Foundation
import SwiftUI
import SceneKit
import ARKit

struct ContentView: View {
    @State var scale: CGFloat = 0.5
    @State var orbitOpacity: CGFloat = 0
    @State var continueOpacity: CGFloat = 1
    @State var showContinue: Bool = false
    @State var showLogo: CGFloat = 0
    @State var initialOpacity: CGFloat = 1
    @State var initialOffset: CGFloat = 0
    @State var showInitial: Bool = true
    @State var showTalking: Bool = false
    @State var showInfo: Bool = false
    
    @State private var writing: Bool = false
    @State private var movingCursor: Bool = false
    @State private var blinkingCursor: Bool = false
    @State private var displayText: String = ""
    @State private var hintTextOpacity: CGFloat = 0
    
    @State private var moveOnY: Bool = true
        
    let cursorColor = Color(#colorLiteral(red: 0, green: 0.368627451, blue: 1, alpha: 1))
    
    var body: some View {
        VStack {
            if showInitial {
                Group {
                    HStack {
                        if showLogo == 1 {
                            Image("orbit-logo")
                                .onAppear() {
                                    withAnimation(.easeInOut.delay(1)) {
                                        showContinue = true
                                    }
                                }
                                .padding(.trailing)
                        }

                        Text("Orbit")
                            .font(.system(size: 80))
                            .opacity(orbitOpacity)
                            .scaleEffect(scale)
                            .onAppear() {
                                withAnimation(.easeOut(duration: 1.5).delay(1)) {
                                    scale = 1
                                    orbitOpacity = 1
                                }
                            }
                            .padding(.bottom)
                            .onAnimationCompleted(for: scale) {
                                withAnimation(.easeIn) {
                                    showLogo = 1
                                }
                            }
                    }

                    if showContinue {
                        Button("Continue") {
                            withAnimation(.easeInOut(duration: 1)) {
                                initialOffset = 100
                                initialOpacity = 0
                            }
                        }
                        .onAnimationCompleted(for: initialOpacity) {
                            showInitial = false
                            withAnimation() {
                                displayText = "Woahh, what are those?!"
                                showTalking = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                                    if displayText == "Woahh, what are those?!" {
                                        withAnimation(.easeOut(duration: 4).delay(0.5)) {
                                            hintTextOpacity = 1
                                        }
                                    }
                                }
                            }
                        }
                        .opacity(continueOpacity)
                        .onAppear() {
                            withAnimation(.easeOut(duration: 1).repeatForever(autoreverses: true)) {
                                continueOpacity = 0.65
                            }
                        }
                    }
                }
                .offset(x: 0, y: -initialOffset)
                .opacity(initialOpacity)
            }

            if showTalking {
                ZStack {
                    Simulation(
                        startingFocusOnBody: false,
                        startingShowTrails: true,
                        startingShowVelocityArrows: false,
                        startingGravitationalConstant: 1,
                        startingFocusIndex: 0,
                        startingBodies: [
                            BodyDefiner(name: "Star", mass: 10.0, velocity: SCNVector3(-0.5, 0.5, 0), position: SCNVector3(0, 0, 0), color: UIColor.systemMint),
                            BodyDefiner(name: "Planet", mass: 6.0, velocity: SCNVector3(0.3, 0.3, 0), position: SCNVector3(0, -30, 0), color: UIColor.systemPink),
                        ],
                        showUI: false,
                        allowCameraControl: false,
                        cameraTransform: SCNVector3(-120, 120, 0),
                        showTexture: false
                    )

                    Text("🤖")
                        .font(.system(size: 120))
                        .offset(
                            x: -(UIScreen.main.bounds.size.width/2 - 95),
                            y: moveOnY ? (UIScreen.main.bounds.size.height/2 - 95) : 0
                        )

                    HStack {
                        Text("🤖")
                            .font(.system(size: 120))
                            .offset(
                                x: -(UIScreen.main.bounds.size.width/2 - 95),
                                y: moveOnY ? (UIScreen.main.bounds.size.height/2 - 95) : 0
                            )
                            .opacity(0)

                        let textWidth = displayText.widthOfString(usingFont: UIFont.preferredFont(forTextStyle: .body))
                        
                        VStack {
                            
                            HStack {
                                Text(displayText)
                                    .font(.body)
                                    .mask(Rectangle().offset(x: writing ? 0 : -textWidth))
                                    .multilineTextAlignment(.center)
                                Rectangle()
                                    .fill(cursorColor)
                                    .opacity(blinkingCursor ? 1 : 0)
                                    .frame(width: 2, height: 24)
                                    .offset(x: movingCursor ? 0 : -(textWidth + 15))
                                    .onAppear() {
                                        withAnimation(.easeOut(duration: 2).delay(3)) {
                                            writing.toggle()
                                            movingCursor.toggle()
                                        }

                                        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(2)) {
                                            blinkingCursor.toggle()
                                        }
                                    }
                            }
                            
                            Text("tap text above to continue")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .opacity(hintTextOpacity)
                        }

                    }
                    .offset(
                        y: moveOnY ? (UIScreen.main.bounds.size.height/2 - 80) : 0
                    )
                    .onTapGesture {
                        if displayText == "Woahh, what are those?!" {
                            withAnimation(.easeOut(duration: 0.5)) {
                                writing.toggle()
                                movingCursor.toggle()
                            }
                            
                            withAnimation(.easeOut(duration: 1.5).delay(0.5)) {
                                hintTextOpacity = 0
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 2).delay(0.5)) {
                                    displayText = "Let me ask Siri really quickly"
                                    writing.toggle()
                                    movingCursor.toggle()
                                }
                            }
                        } else if displayText == "Let me ask Siri really quickly" {
                            withAnimation(.easeOut(duration: 0.5)) {
                                writing.toggle()
                                movingCursor.toggle()
                            }

                            withAnimation(.easeInOut(duration: 3)) {
                                moveOnY = false
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 2).delay(0.5)) {
                                    displayText = "oH, they're planets in orbit!!"
                                    writing.toggle()
                                    movingCursor.toggle()
                                }
                            }
                        } else if displayText == "oH, they're planets in orbit!!" {
                            withAnimation(.easeOut(duration: 0.5)) {
                                writing.toggle()
                                movingCursor.toggle()
                            }

                            withAnimation(.easeInOut(duration: 3)) {
                                moveOnY = false
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 2).delay(0.5)) {
                                    displayText = "They must follow ~gravity~ (very cool)"
                                    writing.toggle()
                                    movingCursor.toggle()
                                }
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 1)) {
                                showInfo = true
                                showTalking = false
                            }
                        }
                    }
                }
            }

            if showInfo {
                withAnimation(.easeInOut) {
                    InfoView()
                        .transition(.opacity)
                }
            }
        }
    }
}

struct SimulationView: View {
    var body: some View {
        Simulation(
            startingFocusOnBody: true,
            startingShowTrails: true,
            startingShowVelocityArrows: false,
            startingGravitationalConstant: 1,
            startingFocusIndex: 0,
            startingBodies: [
                BodyDefiner(name: "Sun", mass: 20.0, velocity: SCNVector3(0, 0, 0), position: SCNVector3(0, 0, 0), color: UIColor.systemYellow),
                BodyDefiner(name: "Earth", mass: 6.0, velocity: SCNVector3(-0.65, 0, 0), position: SCNVector3(0, -70, 0), color: UIColor.systemGreen),
                BodyDefiner(name: "Moon", mass: 1, velocity: SCNVector3(0, 0, 0.025), position: SCNVector3(0, -85, 0), color: UIColor.systemBlue),
                BodyDefiner(name: "Mars", mass: 5.0, velocity: SCNVector3(0.4, 0, 0), position: SCNVector3(0, -150, 0), color: UIColor.systemRed),
            ],
            showUI: true,
            allowCameraControl: true,
            showTexture: true
        )
    }
}

struct InfoView: View {
    @State var showSimulation: Bool = false
    
    var body: some View {
        if showSimulation {
            withAnimation(.spring()) {
                SimulationView()
                    .transition(.slide)
            }
        } else {
            ScrollView {
                Spacer()
                    .frame(height: 50)
                
                Text("Newton's Universal Law of Gravitation")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Image("equation")
                    .colorInvert()
                    .padding(30)
                
                Text("Newton's Universal Law of Gravition is a rule that predicts the movement of bodies by stating that every object in the universe excerts some gravitational force on every other object nearby it. This is predicted by the equation above.")
                    .multilineTextAlignment(.center)
                    .padding(15)
                
                Text("So what does the rule mean? Well, why does the Moon stay close to the Earth and not just fly into the Sun? Why do we stay on the Earth and not just fly off? Because both the moon and us are within the Earth's gravitional field, and the mass of the Earth is big enough to keep us both attracted.")
                    .multilineTextAlignment(.center)
                    .padding(15)
                
                Text("So why does the moon not fall into the earth then? Well think of it like this: if I throw a ball, it will eventually hit the ground. If I throw the ball further, it will hit the ground further. But if I throw the ball so strong that it never hits the ground, the ball would be in **orbit**. Like this, the moon is actually always falling towards the Earth, but the Earth just moves away too fast!")
                    .multilineTextAlignment(.center)
                    .padding(15)
                
                Text("To summarise, this rule can be used to describe the motion of any object in space, such as the satellites in space, the Earth or the Moon! You can watch [this great video](https://www.youtube.com/watch?v=kxkFaBG6a-A) if you'd like to learn more")
                    .multilineTextAlignment(.center)
                    .padding(15)
                
                Button("Now Let's Play!") {
                    withAnimation(.spring()) {
                        showSimulation = true
                    }
                }
                .buttonStyle(BorderedButtonStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
