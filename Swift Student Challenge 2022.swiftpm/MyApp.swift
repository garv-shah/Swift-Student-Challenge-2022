import SwiftUI
import SceneKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                startingFocusOnBody: true,
                startingShowTrails: true,
                startingShowVelocityArrows: false,
                startingGravitationalConstant: 1,
                startingFocusIndex: 2,
                startingBodies: [
                    BodyDefiner(name: "Sun", mass: 10.0, velocity: SCNVector3(0, 0, 0), position: SCNVector3(0, 0, 0), color: UIColor.systemYellow),
                    BodyDefiner(name: "Earth", mass: 4.0, velocity: SCNVector3(0, 0, 0.8), position: SCNVector3(20, 0, 0), color: UIColor.systemGreen),
                    BodyDefiner(name: "Meteor", mass: 1.0, velocity: SCNVector3(0, 0, -0.8), position: SCNVector3(30, 0, 0), color: UIColor.systemBlue)
                ]
            )
                .preferredColorScheme(.dark)
        }
    }
}
