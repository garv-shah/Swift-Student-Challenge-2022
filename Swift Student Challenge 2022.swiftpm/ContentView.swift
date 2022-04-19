import SwiftUI
import SceneKit
import Foundation


struct ContentView: View {
    
    let solarscene = SolarScene() //creates the scene, camera and viewOptions
    @State private var sideButtonsX: CGFloat = 100
    @State private var sideButtonsOpacity: CGFloat = 0
    @State private var sideButtonsExpanded: Bool = false
    
    @State var isPresented: Bool = false
    
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
                solarscene.createAndPutBoxOnRoot()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "trash").foregroundColor(.white), align: ButtonAlign.right, customY: 160, customX: sideButtonsX, opacity: sideButtonsOpacity) {
                solarscene.scene.rootNode.childNode(withName: "box", recursively: false)?.removeFromParentNode()
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "play.fill").foregroundColor(.white), align: ButtonAlign.centre) {
                // do something
            }
            
            .floatingActionButton(color: .blue, image: Image(systemName: "gear").foregroundColor(.white), align: ButtonAlign.left) {
                isPresented.toggle()
            }
            
            .sheetWithDetents(
                        isPresented: $isPresented,
                        detents: [.medium(),.large()]
                    ) {
                        print("The sheet has been dismissed")
                    } content: {
                        Group {
                            Text("Garv")
                                .bold()
                            +
                            Text(" says hi to ")
                            +
                            Text("Will")
                                .bold()
                        }
                        .font(.title)
                    }
        }
    }
}
