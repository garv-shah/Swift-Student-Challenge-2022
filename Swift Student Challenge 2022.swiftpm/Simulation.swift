import SwiftUI
import SceneKit
import Foundation
import SlideOverCard
import Combine


struct Simulation: View {
    
    @State var solarscene = SolarScene(
        focusOnBody: false,
        focusIndex: 0,
        trails: false,
        velocityArrows: false,
        gravitationalConstant: 1,
        inputBodies: [],
        allowCameraControl: true
    )
    
    @State private var sideButtonsX: CGFloat = 100
    @State private var sideButtonsOpacity: CGFloat = 0
    @State private var sideButtonsExpanded: Bool = false
    @State private var isEditPresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    @State private var isDeletePresented: Bool = false
    @State private var isRandomPresented: Bool = false
    
    
    @State private var selectedBody: String = ""
    @State private var selectedBodyName: String = ""
    @State private var selectedBodyMass: String = ""
    @State private var selectedBodyColour: Color = .accentColor
    
    @State private var selectedBodyVelocityX: String = ""
    @State private var selectedBodyVelocityY: String = ""
    @State private var selectedBodyVelocityZ: String = ""
    
    @State private var selectedBodyPositionX: String = ""
    @State private var selectedBodyPositionY: String = ""
    @State private var selectedBodyPositionZ: String = ""
    
    @State private var massRangeLower: String = "1.00"
    @State private var massRangeUpper: String = "20.00"
    @State private var positionRangeLower: String = "-70.00"
    @State private var positionRangeUpper: String = "70.00"
    @State private var velocityRangeLower: String = "-0.80"
    @State private var velocityRangeUpper: String = "0.80"
    @State private var bodynumRangeLower: String = "3"
    @State private var bodynumRangeUpper: String = "9"
    
    
    @State private var availableBodies: [String] = []
    @State private var focusOnBody: Bool = false
    @State private var showTrails: Bool = false
    @State private var showVelocityArrows: Bool = false
    @State private var gravitationalConstant: CGFloat = 1
    @State private var playing: Bool = false
    
    var startingFocusOnBody: Bool
    var startingShowTrails: Bool
    var startingShowVelocityArrows: Bool
    var startingGravitationalConstant: CGFloat
    var startingFocusIndex: Int
    var startingBodies: [BodyDefiner]
    var showUI: Bool
    var allowCameraControl: Bool
    var cameraTransform: SCNVector3 = SCNVector3(0, 0, 0)
    
    init(startingFocusOnBody: Bool, startingShowTrails: Bool, startingShowVelocityArrows: Bool, startingGravitationalConstant: CGFloat, startingFocusIndex: Int, startingBodies: [BodyDefiner], showUI: Bool, allowCameraControl: Bool, cameraTransform: SCNVector3 = SCNVector3(0, 0, 0)) {
        self.startingFocusOnBody = startingFocusOnBody
        self.startingShowTrails = startingShowTrails
        self.startingShowVelocityArrows = startingShowVelocityArrows
        self.startingGravitationalConstant = startingGravitationalConstant
        self.startingFocusIndex = startingFocusIndex
        self.startingBodies = startingBodies
        self.showUI = showUI
        self.allowCameraControl = allowCameraControl
        self.cameraTransform = cameraTransform
        
        solarscene.focusOnBody = startingFocusOnBody
        solarscene.focusIndex = startingFocusIndex
        solarscene.trails = startingShowTrails
        solarscene.velocityArrows = startingShowVelocityArrows
        solarscene.gravitationalConstant = gravitationalConstant
        solarscene.inputBodies = startingBodies
        solarscene.loadNewBodies()
    }
    
    var body: some View {
        if showUI {
            VStack {

                SceneView(
                        scene: solarscene.scene,
                        pointOfView: solarscene.camera,
                        options: solarscene.viewOptions
                )


                        // show side menu button
                        .floatingActionButton(color: .accentColor, image: Image(systemName: "plus").foregroundColor(.white), align: ButtonAlign.right) {
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

                        // edit button
                        .floatingActionButton(color: .accentColor, image: Image(systemName: "pencil").foregroundColor(.white), align: ButtonAlign.right, customY: 80, customX: sideButtonsX, opacity: sideButtonsOpacity) {
                            availableBodies = solarscene.bodies.map({ (body) in
                                return body.internalName
                            })

                            if availableBodies.count > 0 {
                                selectedBody = availableBodies[0]
                                selectedBodyName = selectedBody
                                selectedBodyMass = String(format: "%.2f", solarscene.bodies[0].mass)
                                selectedBodyColour = Color(solarscene.bodies[0].color)

                                selectedBodyVelocityX = String(format: "%.2f", solarscene.bodies[0].initialVelocity.x)
                                selectedBodyVelocityY = String(format: "%.2f", solarscene.bodies[0].initialVelocity.y)
                                selectedBodyVelocityZ = String(format: "%.2f", solarscene.bodies[0].initialVelocity.z)

                                selectedBodyPositionX = String(format: "%.2f", solarscene.bodies[0].initialPosition.x)
                                selectedBodyPositionY = String(format: "%.2f", solarscene.bodies[0].initialPosition.y)
                                selectedBodyPositionZ = String(format: "%.2f", solarscene.bodies[0].initialPosition.z)
                            }

                            isEditPresented.toggle()
                        }

                        // delete all button
                        .floatingActionButton(color: .accentColor, image: Image(systemName: "trash").foregroundColor(.white), align: ButtonAlign.right, customY: 160, customX: sideButtonsX, opacity: sideButtonsOpacity) {
                            isDeletePresented.toggle()
                        }

                        // randomise button
                        .floatingActionButton(color: .accentColor, image: Image(systemName: "shuffle").foregroundColor(.white), align: ButtonAlign.right, customY: 240, customX: sideButtonsX, opacity: sideButtonsOpacity) {
                            isRandomPresented.toggle()
                        }

                        // play and pause button
                        .floatingActionButton(color: .accentColor, image: Image(systemName: playing ? "pause.fill" : "play.fill").foregroundColor(.white), align: ButtonAlign.centre) {
                            if solarscene.bodies.count > 0 {
                                if solarscene.counter == 0 {
                                    solarscene.startLoop()
                                } else {
                                    solarscene.pauseLoop()
                                }
                            }
                            playing.toggle()
                        }

                        // settings button
                        .floatingActionButton(color: .accentColor, image: Image(systemName: "gear").foregroundColor(.white), align: ButtonAlign.left) {
                            availableBodies = solarscene.bodies.map({ (body) in
                                return body.internalName
                            })

                            if availableBodies.count > 0 {
                                selectedBody = availableBodies[solarscene.focusIndex]
                            }
                            focusOnBody = solarscene.focusOnBody
                            showTrails = solarscene.trails
                            showVelocityArrows = solarscene.velocityArrows
                            gravitationalConstant = solarscene.gravitationalConstant

                            isSettingsPresented.toggle()
                        }

                        // Edit Button Slideover
                        .slideOverCard(isPresented: $isEditPresented) {
                            VStack {
                                Group {
                                    Text("Edit Bodies:")
                                            .fontWeight(.bold)
                                            .font(.title)

                                    Text("Please choose a body")
                                            .font(.subheadline)
                                            .padding(.top)

                                    Picker("Please choose a body", selection: $selectedBody) {
                                        ForEach(availableBodies + ["New..."], id: \.self) {
                                            Text($0)
                                        }
                                    }
                                            .onChange(of: selectedBody) { newValue in
                                                if newValue == "New..." {
                                                    selectedBodyName = planetNames.randomElement() ?? "random planet name"
                                                    selectedBodyMass = String(format: "%.2f", CGFloat.random(in: 1.00...20.00))
                                                    selectedBodyColour = Color.random

                                                    selectedBodyVelocityX = String(format: "%.2f", CGFloat.random(in: -0.80...0.80))
                                                    selectedBodyVelocityY = String(format: "%.2f", CGFloat.random(in: -0.80...0.80))
                                                    selectedBodyVelocityZ = String(format: "%.2f", CGFloat.random(in: -0.80...0.80))

                                                    selectedBodyPositionX = String(format: "%.2f", CGFloat.random(in: -40.00...40.00))
                                                    selectedBodyPositionY = String(format: "%.2f", CGFloat.random(in: -40.00...40.00))
                                                    selectedBodyPositionZ = String(format: "%.2f", CGFloat.random(in: -40.00...40.00))
                                                } else {
                                                    let index = availableBodies.firstIndex(of: selectedBody) ?? 0
                                                    selectedBodyName = newValue
                                                    selectedBodyMass = String(format: "%.2f", solarscene.bodies[index].mass)
                                                    selectedBodyColour = Color(solarscene.bodies[index].color)

                                                    selectedBodyVelocityX = String(format: "%.2f", solarscene.bodies[index].initialVelocity.x)
                                                    selectedBodyVelocityY = String(format: "%.2f", solarscene.bodies[index].initialVelocity.y)
                                                    selectedBodyVelocityZ = String(format: "%.2f", solarscene.bodies[index].initialVelocity.z)

                                                    selectedBodyPositionX = String(format: "%.2f", solarscene.bodies[index].initialPosition.x)
                                                    selectedBodyPositionY = String(format: "%.2f", solarscene.bodies[index].initialPosition.y)
                                                    selectedBodyPositionZ = String(format: "%.2f", solarscene.bodies[index].initialPosition.z)
                                                }
                                            }
                                }

                                Divider()

                                Group {
                                    HStack {
                                        Text("Name:")

                                        TextField(selectedBodyName, text: $selectedBodyName)
                                                .textFieldStyle(.roundedBorder)
                                                .multilineTextAlignment(.center)
                                    }

                                    HStack {
                                        Text("Mass:")
                                        UIUnsignedInput(label: nil, binding: $selectedBodyMass, inputText: selectedBodyMass)
                                    }

                                    ColorPicker("Body Colour:", selection: $selectedBodyColour, supportsOpacity: false)
                                }

                                Group {

                                    Spacer()
                                            .frame(height: 20)

                                    HStack {
                                        Text("Velocity:")
                                        UISignedInput(label: "X", binding: $selectedBodyVelocityX, inputText: selectedBodyVelocityX)
                                        UISignedInput(label: "Y", binding: $selectedBodyVelocityY, inputText: selectedBodyVelocityY)
                                        UISignedInput(label: "Z", binding: $selectedBodyVelocityZ, inputText: selectedBodyVelocityZ)
                                    }

                                    Spacer()
                                            .frame(height: 20)

                                    HStack {
                                        Text("Position:")
                                        UISignedInput(label: "X", binding: $selectedBodyPositionX, inputText: selectedBodyPositionX)
                                        UISignedInput(label: "Y", binding: $selectedBodyPositionY, inputText: selectedBodyPositionY)
                                        UISignedInput(label: "Z", binding: $selectedBodyPositionZ, inputText: selectedBodyPositionZ)
                                    }

                                    Divider()

                                    Spacer()
                                            .frame(height: 20)
                                }

                                HStack {
                                    Button("Delete", action: {
                                        if selectedBody != "New..." {
                                            if solarscene.focusIndex == solarscene.bodies.count - 1 {
                                                solarscene.focusIndex -= 1
                                            }

                                            solarscene.scene.rootNode.childNode(withName: solarscene.bodies[availableBodies.firstIndex(of: selectedBody) ?? 0].planetBody?.name ?? "planet", recursively: false)?.removeFromParentNode()
                                            solarscene.bodies.remove(at: availableBodies.firstIndex(of: selectedBody) ?? 0)

                                            availableBodies.removeAll { (body) in
                                                body == selectedBody
                                            }

                                            if availableBodies.count > 0 {
                                                selectedBody = availableBodies[0]
                                            } else {
                                                selectedBody = "New..."

                                                selectedBodyName = planetNames.randomElement() ?? "random planet name"
                                                selectedBodyMass = String(format: "%.2f", CGFloat.random(in: 1.00...20.00))
                                                selectedBodyColour = Color.random

                                                selectedBodyVelocityX = String(format: "%.2f", CGFloat.random(in: -0.80...0.80))
                                                selectedBodyVelocityY = String(format: "%.2f", CGFloat.random(in: -0.80...0.80))
                                                selectedBodyVelocityZ = String(format: "%.2f", CGFloat.random(in: -0.80...0.80))

                                                selectedBodyPositionX = String(format: "%.2f", CGFloat.random(in: -40.00...40.00))
                                                selectedBodyPositionY = String(format: "%.2f", CGFloat.random(in: -40.00...40.00))
                                                selectedBodyPositionZ = String(format: "%.2f", CGFloat.random(in: -40.00...40.00))
                                            }
                                        }

                                        isEditPresented = false
                                    })
                                            .padding(.trailing)

                                    Divider()
                                            .frame(height: 20)

                                    Button("Confirm", action: {
                                        print(selectedBody)
                                        if selectedBody != "New..." {
                                            solarscene.inputBodies[availableBodies.firstIndex(of: selectedBody) ?? 0].name = selectedBodyName
                                            solarscene.inputBodies[availableBodies.firstIndex(of: selectedBody) ?? 0].mass = CGFloat(Double(selectedBodyMass) ?? 1)
                                            solarscene.inputBodies[availableBodies.firstIndex(of: selectedBody) ?? 0].velocity = SCNVector3(x: Float(selectedBodyVelocityX) ?? 1, y: Float(selectedBodyVelocityY) ?? 1, z: Float(selectedBodyVelocityZ) ?? 1)
                                            solarscene.inputBodies[availableBodies.firstIndex(of: selectedBody) ?? 0].position = SCNVector3(x: Float(selectedBodyPositionX) ?? 1, y: Float(selectedBodyPositionY) ?? 1, z: Float(selectedBodyPositionZ) ?? 1)
                                            solarscene.inputBodies[availableBodies.firstIndex(of: selectedBody) ?? 0].color = UIColor(selectedBodyColour)
                                        } else {
                                            solarscene.inputBodies.append(BodyDefiner(name: selectedBodyName, mass: CGFloat(Double(selectedBodyMass) ?? 1), velocity: SCNVector3(x: Float(selectedBodyVelocityX) ?? 1, y: Float(selectedBodyVelocityY) ?? 1, z: Float(selectedBodyVelocityZ) ?? 1), position: SCNVector3(x: Float(selectedBodyPositionX) ?? 1, y: Float(selectedBodyPositionY) ?? 1, z: Float(selectedBodyPositionZ) ?? 1), color: UIColor(selectedBodyColour)))
                                        }

                                        solarscene.pauseLoop()
                                        solarscene = SolarScene(
                                            focusOnBody: solarscene.focusOnBody, focusIndex: solarscene.focusIndex, trails: solarscene.trails, velocityArrows: solarscene.velocityArrows, gravitationalConstant: solarscene.gravitationalConstant, inputBodies: solarscene.inputBodies, allowCameraControl: true
                                        )

                                        playing = false

                                        isEditPresented = false
                                    })
                                            .padding(.leading)
                                }
                                        .padding(.bottom)
                            }
                                    .frame(maxWidth: .infinity, alignment: .center)
                        }

                        // Settings Button Slideover
                        .slideOverCard(isPresented: $isSettingsPresented) {
                            VStack {
                                Text("Settings:")
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .padding(.bottom)

                                if availableBodies.count > 0 {
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

                                    HStack {
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

                                        Spacer()
                                                .frame(width: 20)

                                        Toggle(isOn: $showVelocityArrows) {
                                            Label("Show Velocity", systemImage: "arrow.up.right")
                                        }
                                                .toggleStyle(.button)
                                                .padding(.bottom)
                                    }

                                    Divider()
                                            .padding(.top)

                                    HStack {
                                        Text("Gravitational Constant:")
                                                .multilineTextAlignment(.center)

                                        let formatter: NumberFormatter = {
                                            let formatter = NumberFormatter()
                                            formatter.numberStyle = .decimal
                                            return formatter
                                        }()

                                        TextField("Enter a Gravitational Constant", value: $gravitationalConstant, formatter: formatter)
                                                .textFieldStyle(.roundedBorder)
                                                .keyboardType(.decimalPad)
                                                .padding()
                                                .multilineTextAlignment(.center)
                                    }

                                    Divider()
                                            .padding(.bottom)

                                } else {
                                    Text("There are no bodies in the current scene")
                                            .padding(.bottom)
                                            .multilineTextAlignment(.center)
                                }

                                HStack {
                                    Button("Restart", action: {
                                        solarscene.pauseLoop()
                                        solarscene = SolarScene(
                                            focusOnBody: startingFocusOnBody, focusIndex: startingFocusIndex, trails: startingShowTrails, velocityArrows: startingShowVelocityArrows, gravitationalConstant: startingGravitationalConstant, inputBodies: startingBodies, allowCameraControl: true
                                        )
                                        isSettingsPresented = false
                                        playing = false
                                    })
                                            .padding(.trailing)

                                    Divider()
                                            .frame(height: 20)

                                    Button(availableBodies.count > 0 ? "Confirm" : "Dismiss", action: {
                                        solarscene.pauseLoop()
                                        solarscene = SolarScene(
                                                focusOnBody: focusOnBody, focusIndex: availableBodies.firstIndex(of: selectedBody) ?? 0, trails: showTrails, velocityArrows: showVelocityArrows, gravitationalConstant: gravitationalConstant, inputBodies: solarscene.inputBodies, allowCameraControl: true
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

                        // Delete All Button Slideover
                        .slideOverCard(isPresented: $isDeletePresented) {
                            VStack {
                                Text("Delete All Bodies:")
                                        .fontWeight(.bold)
                                        .font(.title)

                                Text("Are you sure you'd like to clear the scene?")
                                        .padding(10)
                                        .multilineTextAlignment(.center)

                                Button("Yes", action: {
                                    solarscene.pauseLoop()
                                    focusOnBody = false
                                    availableBodies = []
                                    solarscene = SolarScene(
                                        focusOnBody: false, focusIndex: 0, trails: showTrails, velocityArrows: showVelocityArrows, gravitationalConstant: gravitationalConstant, inputBodies: [], allowCameraControl: true
                                    )
                                    isDeletePresented = false
                                    playing = false
                                })
                                        .padding(.bottom)
                            }
                                    .frame(maxWidth: .infinity, alignment: .center)
                        }

                        // randomise button slideover
                        .slideOverCard(isPresented: $isRandomPresented) {
                            VStack {
                                Group {
                                    Text("Randomise Bodies:")
                                            .fontWeight(.bold)
                                            .font(.title)

                                    Text("Please select ranges!")
                                            .padding(10)
                                            .multilineTextAlignment(.center)

                                    Spacer()
                                            .frame(height: 20)
                                }

                                Group {

                                    HStack {
                                        Text("Body Amount:")
                                                .frame(width: 120)
                                                .multilineTextAlignment(.center)

                                        UIIntInput(label: "Lower", binding: $bodynumRangeLower, inputText: bodynumRangeLower)
                                        UIIntInput(label: "Upper", binding: $bodynumRangeUpper, inputText: bodynumRangeUpper)
                                    }

                                    Spacer()
                                            .frame(height: 20)

                                    HStack {
                                        Text("Mass:")
                                                .frame(width: 120)
                                                .multilineTextAlignment(.center)

                                        UIUnsignedInput(label: "Lower", binding: $massRangeLower, inputText: massRangeLower)
                                        UIUnsignedInput(label: "Upper", binding: $massRangeUpper, inputText: massRangeUpper)
                                    }

                                    Spacer()
                                            .frame(height: 20)

                                    HStack {
                                        Text("Velocity:")
                                                .frame(width: 120)
                                                .multilineTextAlignment(.center)

                                        UISignedInput(label: "Lower", binding: $velocityRangeLower, inputText: velocityRangeLower)
                                        UISignedInput(label: "Upper", binding: $velocityRangeUpper, inputText: velocityRangeUpper)
                                    }

                                    Spacer()
                                            .frame(height: 20)

                                    HStack {
                                        Text("Position:")
                                                .frame(width: 120)
                                                .multilineTextAlignment(.center)

                                        UISignedInput(label: "Lower", binding: $positionRangeLower, inputText: positionRangeLower)
                                        UISignedInput(label: "Upper", binding: $positionRangeUpper, inputText: positionRangeUpper)
                                    }

                                    Spacer()
                                            .frame(height: 20)
                                }

                                Button("Confirm", action: {
                                    solarscene.pauseLoop()
                                    focusOnBody = false
                                    availableBodies = []
                                    solarscene = SolarScene(
                                            focusOnBody: false, focusIndex: 0, trails: showTrails, velocityArrows: showVelocityArrows, gravitationalConstant: gravitationalConstant, inputBodies: [], allowCameraControl: true
                                    )
                                    playing = false

                                    solarscene.inputBodies = []

                                    for _ in 0...Int.random(in: (Int(bodynumRangeLower) ?? 3)..<(Int(bodynumRangeUpper) ?? 9)) {
                                        selectedBodyName = planetNames.randomElement() ?? "random planet name"
                                        selectedBodyMass = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(massRangeLower) ?? 1.00)...CGFloat(Double(massRangeUpper) ?? 20.00)))
                                        selectedBodyColour = Color.random

                                        selectedBodyVelocityX = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(velocityRangeLower) ?? -0.80)...CGFloat(Double(velocityRangeUpper) ?? 0.80)))
                                        selectedBodyVelocityY = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(velocityRangeLower) ?? -0.80)...CGFloat(Double(velocityRangeUpper) ?? 0.80)))
                                        selectedBodyVelocityZ = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(velocityRangeLower) ?? -0.80)...CGFloat(Double(velocityRangeUpper) ?? 0.80)))

                                        selectedBodyPositionX = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(positionRangeLower) ?? -70.00)...CGFloat(Double(positionRangeUpper) ?? 70.00)))
                                        selectedBodyPositionY = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(positionRangeLower) ?? -70.00)...CGFloat(Double(positionRangeUpper) ?? 70.00)))
                                        selectedBodyPositionZ = String(format: "%.2f", CGFloat.random(in: CGFloat(Double(positionRangeLower) ?? -70.00)...CGFloat(Double(positionRangeUpper) ?? 70.00)))

                                        solarscene.inputBodies.append(BodyDefiner(name: selectedBodyName, mass: CGFloat(Double(selectedBodyMass) ?? 1), velocity: SCNVector3(x: Float(selectedBodyVelocityX) ?? 1, y: Float(selectedBodyVelocityY) ?? 1, z: Float(selectedBodyVelocityZ) ?? 1), position: SCNVector3(x: Float(selectedBodyPositionX) ?? 1, y: Float(selectedBodyPositionY) ?? 1, z: Float(selectedBodyPositionZ) ?? 1), color: UIColor(selectedBodyColour)))
                                    }

                                    solarscene.loadNewBodies()
                                    isRandomPresented = false
                                })
                                        .padding(.bottom)
                            }
                                    .frame(maxWidth: .infinity, alignment: .center)
                        }
            }
        } else {
            VStack {
                SceneView(
                        scene: solarscene.scene,
                        pointOfView: solarscene.camera,
                        options: solarscene.viewOptions
                )
            }
            .onAppear() {
                if !allowCameraControl {
                    solarscene = SolarScene(focusOnBody: solarscene.focusOnBody, focusIndex: solarscene.focusIndex, trails: solarscene.trails, velocityArrows: solarscene.velocityArrows, gravitationalConstant: solarscene.gravitationalConstant, inputBodies: solarscene.inputBodies, allowCameraControl: false, cameraTransform: cameraTransform)
                }
                solarscene.startLoop()
                playing = true
            }
        }
    }
}
