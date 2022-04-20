import SwiftUI
import SceneKit
import Foundation
import SlideOverCard


struct ContentView: View {
    
    let solarscene = SolarScene() //creates the scene, camera and viewOptions
    @State private var sideButtonsX: CGFloat = 100
    @State private var sideButtonsOpacity: CGFloat = 0
    @State private var sideButtonsExpanded: Bool = false
    @State private var isDeletePresented: Bool = false
    @State private var selectedBody: String = ""
    @State private var availableBodies: [String] = []
    
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
                //solarscene.scene.rootNode.childNode(withName: solarscene.bodies[1].planetBody?.name ?? "planet", recursively: false)?.removeFromParentNode()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "play.fill").foregroundColor(.white), align: ButtonAlign.centre) {
                // do something
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "gear").foregroundColor(.white), align: ButtonAlign.left) {
                
            }
            
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
                        solarscene.scene.rootNode.childNode(withName: solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].planetBody?.name ?? "planet", recursively: false)?.removeFromParentNode()
                        isDeletePresented = false
                    })
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
    
        }
    }
}
