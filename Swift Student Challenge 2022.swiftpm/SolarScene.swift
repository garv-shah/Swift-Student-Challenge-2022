//
//  File.swift
//  Swift Student Challenge 2022
//
//  Created by Garv Shah on 18/4/2022.
//

import SwiftUI
import SceneKit
import Foundation

class SolarScene {
    
    let scene: SCNScene
    let camera: SCNNode
    let viewOptions: SceneView.Options
    
    init() {
        
        //create the stuff for SceneView
        scene = SCNScene()
        
        camera = SCNNode()
        camera.camera = SCNCamera()
        camera.camera?.zFar = 500
        camera.position = SCNVector3(x: 0, y: 150, z: 0)
        
        viewOptions = [
            .allowsCameraControl,
            .autoenablesDefaultLighting,
            .temporalAntialiasingEnabled
        ]
        
        //set up the scene object
        scene.background.contents = UIColor.black
        
        struct CelestialBody {
            var internalName: String
            var mass: CGFloat
            var radius: CGFloat
            var initialVelocity: SCNVector3
            var currentVelocity: SCNVector3?
            var initialPosition: SCNVector3
            var color: UIColor
            var planetBody: SCNNode?
            var internalScene: SCNScene
            let gravitationalConstant: CGFloat
            
            
            mutating func initial() {
                currentVelocity = initialVelocity
                let object = SCNSphere(radius: radius)
                let material = object.firstMaterial!
                material.diffuse.contents = color
                let body = SCNNode(geometry: object)
                body.name = "planet_" + internalName + "_" + "\(mass)"
                let trail = SCNParticleSystem()
                trail.birthRate = 10000
                //trail.particleLifeSpan = 4
                trail.particleSize = 0.1
                trail.particleColor = color.withAlphaComponent(0.1)
                trail.emitterShape = SCNSphere(radius: 1)
                trail.particleImage = #imageLiteral(resourceName: "trail.png")
                body.addParticleSystem(trail)
                planetBody = body
                internalScene.rootNode.addChildNode(body)
                planetBody!.position = initialPosition
            }
            
            mutating func updateVelocity(timeStep: Double) {
                for otherBody in internalScene.rootNode.childNodes(passingTest: {
                    (node, stop) -> Bool in
                    return (node.name?.components(separatedBy: "_")[0] == "planet") && (node.name?.components(separatedBy: "_")[1] != internalName)
                }) {
                    let sqrDst: CGFloat = sqrMagnitude(point: (otherBody.position - self.planetBody!.position))
                    let forceDir: SCNVector3 = (otherBody.position - self.planetBody!.position).normalized
                    let otherBodyMass = CGFloat(Double(otherBody.name?.components(separatedBy: "_")[2] ?? "0") ?? 0)
                    let force: SCNVector3 = forceDir * gravitationalConstant * (self.mass * otherBodyMass) / sqrDst
                    let acceleration: SCNVector3 = force / self.mass
                    currentVelocity = currentVelocity! + (acceleration * timeStep)
                }
            }
            
            mutating func updatePosition(timeStep: Double, focusBody: CelestialBody? = nil) {
                self.planetBody!.position = self.planetBody!.position + (currentVelocity! * timeStep) - (focusBody?.returnPosition(timeStep: timeStep) ?? SCNVector3(0, 0, 0))
            }
            
            func returnPosition(timeStep: Double) -> SCNVector3 {
                return (self.planetBody!.position + (currentVelocity! * timeStep))
            }
        }
        
        var bodies: [CelestialBody] = [
            CelestialBody(internalName: "sun", mass: 10.0, radius: 10.0, initialVelocity: SCNVector3(0, 0, 0), initialPosition: SCNVector3(0, 0, 0), color: UIColor.yellow, internalScene: scene, gravitationalConstant: 1),
            CelestialBody(internalName: "earth", mass: 4.0, radius: 4.0, initialVelocity: SCNVector3(0, 0, 0.8), initialPosition: SCNVector3(20, 0, 0), color: UIColor.green, internalScene: scene, gravitationalConstant: 1),
            CelestialBody(internalName: "moon", mass: 1.0, radius: 1.0, initialVelocity: SCNVector3(0, 0, -0.8), initialPosition: SCNVector3(30, 0, 0), color: UIColor.blue, internalScene: scene, gravitationalConstant: 1)
        ]
        
        let focusOnBody = true
        let focusIndex = 0
        
        for i in 0...bodies.count - 1 {
            bodies[i].initial()
        }
        
        camera.look(at: bodies[focusIndex].planetBody!.position)
        var counter: Double = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { (_) in
            for i in 0...bodies.count - 1 {
                bodies[i].updateVelocity(timeStep: counter)
            }
            
            for i in 0...bodies.count - 1 {
                if focusOnBody {
                    bodies[i].updatePosition(timeStep: counter, focusBody: bodies[focusIndex])
                } else {
                    bodies[i].updatePosition(timeStep: counter)
                }
            }
            
            //self.camera.position = SCNVector3(x: bodies[focusIndex].planetBody!.position.x, y: bodies[focusIndex].planetBody!.position.y + 150, z: bodies[focusIndex].planetBody!.position.z)
            counter = 1.25 * sqrt(counter) + 0.01
        }
        
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        print("test")
//    }
    
    func createAndPutBoxOnRoot() {
        
        //create box geometry
        let box = SCNBox(width: 20, height: 29, length: 10, chamferRadius: 0.2)
        
        //create material for box geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        material.lightingModel = .blinn
        
        //set the material on the box (array because several materials can be applied)
        box.materials = [material]
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "box"
        
        //set the box as the geometry of the scenes root node (the only SCNNode in this scene)
        scene.rootNode.addChildNode(boxNode)
        
    }
    
}
