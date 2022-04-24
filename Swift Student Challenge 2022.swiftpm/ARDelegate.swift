//
//  File.swift
//  Orbit
//
//  Created by Garv Shah on 22/4/2022.
//

import Foundation
import SceneKit
import ARKit

class ARDelegate: NSObject, ARSCNViewDelegate, ObservableObject {
    var arView: ARSCNView?
    
    func setARView(_ arView: ARSCNView, solar: SolarScene) {
        self.arView = arView
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)
        
        arView.delegate = self

        arView.scene = solar.scene
    }
}
