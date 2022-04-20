import SwiftUI
import SceneKit
import Foundation
import SlideOverCard


struct ContentView: View {
    
    @State var solarscene = SolarScene(
        focusOnBody: true, focusIndex: 2, trails: true
    )
    
    @State private var sideButtonsX: CGFloat = 100
    @State private var sideButtonsOpacity: CGFloat = 0
    @State private var sideButtonsExpanded: Bool = false
    @State private var isDeletePresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    @State private var selectedBody: String = ""
    @State private var availableBodies: [String] = []
    @State private var focusOnBody: Bool = false
    @State private var showTrails: Bool = false
    @State private var playing: Bool = false
    
    var body: some View {
        VStack {
            
            SceneView(
                scene: solarscene.scene,
                pointOfView: solarscene.camera,
                options: solarscene.viewOptions
            )
            
            .floatingActionButton(color: .blue, image: Image(systemName: "pencil").foregroundColor(.white), align: ButtonAlign.right) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if sideButtonsExpanded {
                        sideButtonsX += 100
                        sideButtonsOpacity -= 1
                    } else {
                        sideButtonsX -= 100
                        sideButtonsOpacity += 1
                    }
                }
                
                sideButtonsExpanded.toggle()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "plus").foregroundColor(.white), align: ButtonAlign.right, customY: 80, customX: sideButtonsX, opacity: sideButtonsOpacity) {
                solarscene.createBody()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "trash").foregroundColor(.white), align: ButtonAlign.right, customY: 160, customX: sideButtonsX, opacity: sideButtonsOpacity) {
                availableBodies = solarscene.bodies.map({ (body) in
                    return body.internalName
                })
                
                selectedBody = availableBodies[0]
                
                isDeletePresented.toggle()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: playing ? "pause.fill" : "play.fill").foregroundColor(.white), align: ButtonAlign.centre) {
                if solarscene.counter == 0 {
                    solarscene.startLoop()
                } else {
                    solarscene.pauseLoop()
                }
                playing.toggle()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "gear").foregroundColor(.white), align: ButtonAlign.left) {
                availableBodies = solarscene.bodies.map({ (body) in
                    return body.internalName
                })
                
                selectedBody = availableBodies[solarscene.focusIndex]
                focusOnBody = solarscene.focusOnBody
                showTrails = solarscene.trails
                
                isSettingsPresented.toggle()
            }
            
            // Delete Button Slideover
            .slideOverCard(isPresented: $isDeletePresented) {
                VStack {
                    Text("Delete Body:")
                        .fontWeight(.bold)
                        .font(.title)
                    
                    Picker("Please choose a body", selection: $selectedBody) {
                        ForEach(availableBodies, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Text("You selected \"\(selectedBody)\", which has a mass of \(String(format: "%.2f", solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].mass)) and a colour of \(solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].color.accessibilityName)")
                        .padding(10)
                        .multilineTextAlignment(.center)
                    
                    Button("Confirm", action: {
                        if solarscene.focusIndex == solarscene.bodies.count - 1 {
                            solarscene.focusIndex -= 1
                        }
                        
                        solarscene.scene.rootNode.childNode(withName: solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].planetBody?.name ?? "planet", recursively: false)?.removeFromParentNode()
                        solarscene.bodies.remove(at: availableBodies.firstIndex(of: selectedBody) ?? 0)
                        isDeletePresented = false
                    })
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
    
            
            // Settings Button SLideover
            .slideOverCard(isPresented: $isSettingsPresented) {
                VStack {
                    Text("Settings:")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.bottom)
                    
                    Toggle(isOn: $focusOnBody) {
                        Label("Focus On Body", systemImage: "scope")
                    }
                        .onChange(of: focusOnBody) { value in
                            solarscene.focusOnBody = focusOnBody
                        }
                        .toggleStyle(.button)
                    
                    Text("Please choose a body")
                        .font(.subheadline)
                        .padding(.top)
                    
                    Picker("Please choose a body", selection: $selectedBody) {
                        ForEach(availableBodies, id: \.self) {
                            Text($0)
                        }
                    }
                    .disabled(!focusOnBody)
                    
                    Text("You selected \"\(selectedBody)\", which has a mass of \(String(format: "%.2f", solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].mass)) and a colour of \(solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].color.accessibilityName)")
                        .padding(10)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                        .padding(.bottom)
                    
                    Toggle(isOn: $showTrails) {
                        Label("Show Trails", systemImage: "moon.stars")
                    }
                        .onChange(of: showTrails) { value in
                            if value {
                                solarscene.showTrails()
                            } else {
                                solarscene.hideTrails()
                            }
                        }
                        .toggleStyle(.button)
                        .padding(.bottom)
                    
                    HStack {
                        Button("Restart", action: {
                            solarscene.pauseLoop()
                            solarscene = SolarScene(
                                focusOnBody: focusOnBody, focusIndex: availableBodies.firstIndex(of: selectedBody) ?? 0, trails: showTrails
                            )
                            isSettingsPresented = false
                            playing = false
                        })
                        .padding(.trailing)
                        
                        Divider()
                            .frame(height: 20)
                        
                        Button("Confirm", action: {
                            solarscene.pauseLoop()
                            solarscene = SolarScene(
                                focusOnBody: focusOnBody, focusIndex: availableBodies.firstIndex(of: selectedBody) ?? 0, trails: showTrails
                            )
                            isSettingsPresented = false
                            playing = false
                        })
                        .padding(.leading)
                    }
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
